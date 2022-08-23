import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/repositories/utils/util.dart';
import 'package:test_app/utils/settings.dart';

class AuthRepository {
  static Future<String> login(
    http.Client client,
    Map<String, dynamic> data,
  ) async {
    final response = await RepositoryUtils.postData(
      client,
      "${Setting.user}/login",
      data: data,
    );

    // Parse response.
    var body = json.decode(response.body);
    // Converted to User model
    return body["token"];
  }
}
