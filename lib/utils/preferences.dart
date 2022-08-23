import 'package:shared_preferences/shared_preferences.dart';

const String tokenKey = 'UserToken';

class Preferences {
  static Future<bool> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    final isSaved = await preferences.setString(tokenKey, token);
    return isSaved;
  }

  static Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(tokenKey) ?? "";
    return token;
  }

  static Future<bool> removeToken() async {
    final preferences = await SharedPreferences.getInstance();
    final isRemoved = await preferences.remove(tokenKey);
    return isRemoved;
  }
}
