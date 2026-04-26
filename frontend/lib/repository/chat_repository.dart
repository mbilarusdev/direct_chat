import 'package:fixnum/fixnum.dart';
import 'package:frontend/data_source/local/chats_dao.dart';
import 'package:frontend/data_source/local/messages_dao.dart';
import 'package:frontend/data_source/remote/web_socket.dart';
import 'package:frontend/database/local_db.dart';
import 'package:frontend/generated/chat.pb.dart' as pb;

class ChatRepository {
  final WebSocketDataSource _ws;
  final MessagesDao _messagesDao;
  final ChatsDao _chatsDao;
  final String _currentUserId;
  final String _role;

  String get currentUserId => _currentUserId;
  String get role => _role;

  ChatRepository(
    this._ws,
    this._messagesDao,
    this._chatsDao,
    this._currentUserId,
    this._role,
  ) {
    _listenToSocket();
  }

  Stream<List<Message>> watchMessages(String chatId) {
    _requestSync(chatId);
    return _messagesDao.watchMessages(chatId);
  }

  Future<void> deleteChat(String chatId) async {
    await _messagesDao.clearChat(chatId);
    await _chatsDao.deleteChat(chatId);

    final req = pb.DeleteChatRequest()..chatId = chatId;
    _ws.sendAction("delete_chat", req);
  }

  Stream<List<Chat>> watchChats() => _chatsDao.watchAllChats();

  void _listenToSocket() {
    _ws.stream.listen((map) {
      if (map.containsKey('messages')) {
        final syncResp = pb.SyncResponse()..mergeFromProto3Json(map);
        _handleSync(syncResp);
      } else if (map.containsKey('pts') &&
          !map.containsKey('id') &&
          !map.containsKey('text')) {
        // Подтверждение своего действия
        final actionResp = pb.MessageActionResponse()..mergeFromProto3Json(map);
        _handleAction(actionResp);
      } else if (map.containsKey('text')) {
        // Новое сообщение (Broadcast)
        final msg = pb.Message()..mergeFromProto3Json(map);
        _handleIncomingMessage(msg);
      }
    });
  }

  void sendMessage(String chatId, String text) {
    final req = pb.SendMessageRequest()
      ..chatId = chatId
      ..text = text;
    _ws.sendAction("send", req);
  }

  void updateMessage(String chatId, String messageId, String newText) {
    final req = pb.UpdateMessageRequest()
      ..chatId = chatId
      ..messageId = messageId
      ..newText = newText;
    _ws.sendAction("update", req);
  }

  void deleteMessage(String chatId, String messageId) {
    final req = pb.DeleteMessageRequest()
      ..chatId = chatId
      ..messageId = messageId;
    _ws.sendAction("delete", req);
  }

  void _requestSync(String chatId) async {
    final chat = await _chatsDao.getChat(chatId);
    final lastPts = chat?.lastPts ?? BigInt.zero;

    final req = pb.SyncRequest()
      ..chatId = chatId
      ..lastPts = Int64.parseRadix(lastPts.toString(), 10)
      ..userId = _currentUserId;

    _ws.sendAction("sync", req);
  }

  void _handleIncomingMessage(pb.Message msg) async {
    final chat = await _chatsDao.getChat(msg.chatId);
    final currentLocalPts = Int64.parseRadix(
      (chat?.lastPts ?? BigInt.zero).toString(),
      10,
    );
    if (msg.pts > currentLocalPts + 1) {
      _requestSync(msg.chatId);
      return;
    }

    await _messagesDao.insertOrUpdateMessages([msg]);
    await _updateDbPts(msg.chatId, msg.pts);
  }

  void _handleSync(pb.SyncResponse resp) async {
    String chatId = resp.chatId;
    if (chatId.isEmpty && resp.messages.isNotEmpty) {
      chatId = resp.messages.first.chatId;
    }

    if (chatId.isEmpty) return;

    if (resp.fullReload) {
      await _messagesDao.clearChat(chatId);
    }

    if (resp.messages.isNotEmpty) {
      await _messagesDao.insertOrUpdateMessages(resp.messages);
    }

    await _updateDbPts(chatId, resp.currentPts);

    if (resp.readPts > 0) {
      final readBigInt = BigInt.parse(resp.readPts.toString());
      if (_role == "admin") {
        await _chatsDao.updateReadStatus(chatId, userRead: readBigInt);
      } else {
        await _chatsDao.updateReadStatus(chatId, adminRead: readBigInt);
      }
    }
  }

  void _handleAction(pb.MessageActionResponse resp) async {
    if (resp.chatId.isEmpty) return;

    await _updateDbPts(resp.chatId, resp.pts);
  }

  Future<void> _updateDbPts(String chatId, Int64 pts) async {
    await _chatsDao.updateChatPts(chatId, BigInt.parse(pts.toString()));
  }

  void markRead(String chatId, Int64 pts) {
    final req = pb.MarkReadRequest()
      ..chatId = chatId
      ..userId = _currentUserId
      ..pts = pts;
    _ws.sendAction("mark_read", req);
  }

  Stream<Chat> watchChat(String chatId) {
    return _chatsDao.watchChat(
      chatId,
    ); // Этот метод в DAO вернет объект Chat со всеми PTS
  }
}
