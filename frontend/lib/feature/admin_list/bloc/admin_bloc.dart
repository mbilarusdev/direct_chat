import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data_source/local/token_storage.dart';
import 'package:frontend/database/local_db.dart';
import 'package:frontend/repository/auth_repository.dart';
import 'package:frontend/repository/chat_repository.dart';

abstract class AdminEvent {}

// Загрузка списка всех чатов из локальной БД
class LoadAdminData extends AdminEvent {}

// Создание нового клиента через Python API
class CreateClientEvent extends AdminEvent {
  final String companyName;
  CreateClientEvent(this.companyName);
}

// Очистка последней ссылки (если нужно скрыть уведомление в консоли)
class ClearLastLinkEvent extends AdminEvent {}

class AdminState {
  final List<Chat> chats; // Список чатов из Drift
  final String? lastLink; // Ссылка от Python API
  final bool isLoading; // Загрузка списка чатов
  final bool isCreating; // Процесс создания нового клиента
  final String? error;

  AdminState({
    this.chats = const [],
    this.lastLink,
    this.isLoading = false,
    this.isCreating = false, // По умолчанию false
    this.error,
  });

  AdminState copyWith({
    List<Chat>? chats,
    String? lastLink,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return AdminState(
      chats: chats ?? this.chats,
      lastLink: lastLink ?? this.lastLink,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error ?? this.error,
    );
  }
}

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AuthRepository _authRepo;
  final ChatRepository _chatRepo;
  final TokenStorage _tokenStorage;

  AdminBloc(this._authRepo, this._chatRepo, this._tokenStorage)
    : super(AdminState()) {
    on<LoadAdminData>((event, emit) async {
      await emit.forEach(
        _chatRepo.watchChats(),
        onData: (chats) => state.copyWith(chats: chats),
      );
    });

    on<CreateClientEvent>((event, emit) async {
      emit(state.copyWith(isCreating: true)); // Показываем лоадер

      // Достаем токен через репозиторий или напрямую (если прокинули хранилище)
      final String? token = _tokenStorage.getToken();

      if (token == null) {
        emit(state.copyWith(error: "AUTH_TOKEN_MISSING", isCreating: false));
        return;
      }

      final result = await _authRepo.createClient(token, event.companyName);

      if (result != null) {
        emit(
          state.copyWith(lastLink: result['invite_link'], isCreating: false),
        );
      } else {
        emit(state.copyWith(error: "API_ERROR", isCreating: false));
      }
    });
  }
}
