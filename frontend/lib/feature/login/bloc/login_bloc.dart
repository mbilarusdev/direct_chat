// События
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data_source/local/token_storage.dart';
import 'package:frontend/data_source/remote/web_socket.dart';
import 'package:frontend/repository/auth_repository.dart';

abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  LoginSubmitted(this.username, this.password);
}

// Состояния
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  AuthState({this.isLoading = false, this.error, this.isSuccess = false});

  AuthState copyWith({bool? isLoading, String? error, bool? isSuccess}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;
  final TokenStorage _storage;
  final WebSocketDataSource _wsDataSource;

  AuthBloc(this._repo, this._storage, this._wsDataSource) : super(AuthState()) {
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));

      final token = await _repo.login(event.username, event.password);

      if (token != null) {
        await _storage.saveToken(token);
        _wsDataSource.connect("ws://localhost:8080/ws", token);
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: "ACCESS_DENIED: INVALID_CREDENTIALS",
          ),
        );
      }
    });
  }
}
