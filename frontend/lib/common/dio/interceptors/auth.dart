import 'package:dio/dio.dart';
import 'package:frontend/data_source/local/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Если токен протух — чистим его и кидаем юзера на логин
      _storage.clear();
      print("SESSION_EXPIRED: REDIRECT_TO_LOGIN");
    }
    super.onError(err, handler);
  }
}
