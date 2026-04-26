import 'package:drift/drift.dart';
import 'package:frontend/database/local_db.dart';
import 'package:frontend/database/table/chat.dart';

part 'chats_dao.g.dart';

@DriftAccessor(tables: [Chats])
class ChatsDao extends DatabaseAccessor<LocalDatabase> with _$ChatsDaoMixin {
  ChatsDao(super.db);

  Future<Chat?> getChat(String chatId) {
    return (select(chats)..where((t) => t.id.equals(chatId))).getSingleOrNull();
  }

  Future<void> updateChatPts(String chatId, BigInt newPts) {
    return (update(chats)..where((t) => t.id.equals(chatId))).write(
      ChatsCompanion(lastPts: Value(newPts)),
    );
  }

  Future<void> updateReadStatus(
    String chatId, {
    BigInt? adminRead,
    BigInt? userRead,
  }) {
    return (update(chats)..where((t) => t.id.equals(chatId))).write(
      ChatsCompanion(
        adminReadPts: adminRead != null
            ? Value(adminRead)
            : const Value.absent(),
        userReadPts: userRead != null ? Value(userRead) : const Value.absent(),
      ),
    );
  }

  Future<void> deleteChat(String chatId) {
    return (delete(chats)..where((t) => t.id.equals(chatId))).go();
  }

  Stream<List<Chat>> watchAllChats() => select(chats).watch();

  Stream<Chat> watchChat(String chatId) {
    return (select(chats)..where((t) => t.id.equals(chatId))).watchSingle();
  }
}
