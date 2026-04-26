import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = 'admin_jwt_token';
  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  Future<void> saveToken(String token) async =>
      await _prefs.setString(_key, token);

  String? getToken() => _prefs.getString(_key);

  Future<void> clear() async => await _prefs.remove(_key);
}
