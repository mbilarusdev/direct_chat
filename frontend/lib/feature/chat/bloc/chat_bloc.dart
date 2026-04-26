import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/database/local_db.dart';
import 'package:frontend/repository/chat_repository.dart';

abstract class ChatEvent {}

class LoadChatEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String text;
  SendMessageEvent(this.text);
}

class UpdateMessageEvent extends ChatEvent {
  final String messageId;
  final String newText;
  UpdateMessageEvent(this.messageId, this.newText);
}

class DeleteMessageEvent extends ChatEvent {
  final String messageId;
  DeleteMessageEvent(this.messageId);
}

class DeleteChatEvent extends ChatEvent {}

// Состояние
class ChatState {
  final List<Message> messages;
  final bool isSyncing;
  final String? error;

  ChatState({this.messages = const [], this.isSyncing = false, this.error});

  ChatState copyWith({
    List<Message>? messages,
    bool? isSyncing,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSyncing: isSyncing ?? this.isSyncing,
      error: error ?? this.error,
    );
  }
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repo;
  final String _chatId;

  ChatBloc(this._repo, this._chatId) : super(ChatState()) {
    on<LoadChatEvent>((event, emit) async {
      emit(state.copyWith(isSyncing: true));
      // Слушаем БД. Drift сам обновит список при удалении/редактировании записей
      await emit.forEach<List<Message>>(
        _repo.watchMessages(_chatId),
        onData: (data) => state.copyWith(messages: data, isSyncing: false),
      );
    });

    on<SendMessageEvent>(
      (event, emit) => _repo.sendMessage(_chatId, event.text),
    );

    on<UpdateMessageEvent>(
      (event, emit) =>
          _repo.updateMessage(_chatId, event.messageId, event.newText),
    );

    on<DeleteMessageEvent>(
      (event, emit) => _repo.deleteMessage(_chatId, event.messageId),
    );

    on<DeleteChatEvent>((event, emit) => _repo.deleteChat(_chatId));
  }
}
