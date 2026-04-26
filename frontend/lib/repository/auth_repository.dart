import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        "/auth/login",
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        return response.data['access_token'];
      }
    } on DioException catch (e) {
      print("LOGIN_ERROR: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  // Создание клиента
  Future<Map<String, dynamic>?> createClient(
    String adminToken,
    String companyName,
  ) async {
    try {
      final response = await _dio.post(
        "/clients/create",
        data: {"company_name": companyName},
        options: Options(
          headers: {
            "Authorization": "Bearer $adminToken", // Явно передаем здесь
          },
        ),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }
}
