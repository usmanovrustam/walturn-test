import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_app/repositories/utils/exception.dart';
import 'package:test_app/repositories/utils/uri.dart';
import 'package:test_app/utils/logger.dart';
import 'package:test_app/utils/preferences.dart';

class RepositoryUtils {
  // Authorization field
  static Future<Map<String, String>> getAuthorization(String token) async {
    return {'Authorization': "Bearer $token"};
  }

  static Future<Map<String, String>> getHeaders() async {
    final token = await Preferences.getToken();

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Set token.
    if (token.isNotEmpty) headers.addAll(await getAuthorization(token));

    return headers;
  }

  static String getUri(
    String endpointUrl,
    Map<String, dynamic>? params,
  ) =>
      UriUtils.makeEncodedUri(
        endpointUrl,
        queryParameters: params,
      );

  static Future<http.Response> executeRequest(
    http.Client client,
    String endpointUrl, {
    String method = 'get',
    Map<String, dynamic>? data,
  }) async {
    final headers = await getHeaders();
    final uri = Uri.parse(
      getUri(
        endpointUrl,
        (method != 'post' && method != 'put') ? data : null,
      ),
    );
    // logger in this section is visible after the http request is made
    logger.d(<String, dynamic>{
      'TYPE': 'Request >>>',
      'URL': endpointUrl,
      'HEADER': headers,
      'BODY': data
    });

    http.Response response;
    // request types checked for all methods
    try {
      switch (method) {
        case 'put':
          response = await client.put(
            uri,
            headers: headers,
            body: json.encode(data),
          );
          break;
        case 'patch':
          response = await client.patch(
            uri,
            headers: headers,
            body: json.encode(data),
          );
          break;
        case 'post':
          response = await client.post(
            uri,
            headers: headers,
            body: json.encode(data),
          );
          break;
        case 'delete':
          response = await client.delete(uri, headers: headers);
          break;
        default:
          response = await client.get(uri, headers: headers);
          break;
      }
      // logger in this section is visible after the http response is received
      logger.d(<String, dynamic>{
        'TYPE': 'Response <<<',
        'STATUS': response.statusCode,
        'URL': endpointUrl,
        'HEADER': response.headers,
        'BODY': json.decode(response.body),
      });
    } on Exception catch (exp) {
      throw RepositoryException.err(exp);
    }

    // Check for client or server errors.
    if (response.body.isNotEmpty && response.statusCode >= 400) {
      throw RepositoryException(response);
    }

    return response;
  }

  // request types separeted for all methods

  static Future<http.Response> fetchData(
    http.Client client,
    String endpointUrl, {
    Map<String, dynamic>? data,
  }) async {
    return executeRequest(
      client,
      endpointUrl,
      method: 'get',
      data: data,
    );
  }

  static Future<http.Response> postData(
    http.Client client,
    String endpointUrl, {
    Map<String, dynamic>? data,
  }) async {
    return executeRequest(
      client,
      endpointUrl,
      method: 'post',
      data: data,
    );
  }

  static Future<http.Response> putData(
    http.Client client,
    String endpointUrl, {
    Map<String, dynamic>? data,
  }) async {
    return executeRequest(
      client,
      endpointUrl,
      method: 'put',
      data: data,
    );
  }

  static Future<http.Response> patchData(
    http.Client client,
    String endpointUrl, {
    Map<String, dynamic>? data,
  }) async {
    return executeRequest(
      client,
      endpointUrl,
      method: 'patch',
      data: data,
    );
  }

  static Future<http.Response> deleteData(
    http.Client client,
    String endpointUrl,
  ) async {
    return executeRequest(
      client,
      endpointUrl,
      method: 'delete',
    );
  }

  static Future<http.Response> uploadData(
    String endpointUrl,
    List<http.MultipartFile> body,
  ) async {
    var uri = Uri.parse(endpointUrl);
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await getHeaders());
    request.files.addAll(body);

    // Execute request.

    http.Response response;
    try {
      var streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);
    } catch (exp) {
      throw RepositoryException.err(exp as Exception);
    }

    // Check for client or server errors.
    if (response.body.isNotEmpty && response.statusCode >= 400) {
      throw RepositoryException(response);
    }

    return response;
  }
}
