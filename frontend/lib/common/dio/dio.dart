import 'package:dio/dio.dart';
import 'package:frontend/data_source/local/token_storage.dart';

Dio createDio(TokenStorage tokenStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8000/api/v1",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = tokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // Если сервер ответил 401, значит токен невалиден — чистим его
          tokenStorage.clear();
        }
        return handler.next(e);
      },
    ),
  );

  // Включаем логгер для консоли (в режиме отладки)
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('HTTP_LOG: $obj'), // Выводит в твою "консоль"
    ),
  );

  return dio;
}
