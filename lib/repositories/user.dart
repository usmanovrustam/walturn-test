import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/models/user.dart';
import 'package:test_app/repositories/utils/util.dart';
import 'package:test_app/utils/settings.dart';

class UserRepository {
  static Future<UserModel> fetchUser(http.Client client) async {
    final response = await RepositoryUtils.fetchData(
      client,
      "${Setting.user}/me",
    );

    // Parse response.
    var body = json.decode(response.body);
    // Converted to User model
    return UserModel.fromJson(body);
  }
}
