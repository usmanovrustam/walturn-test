import 'dart:convert';

import 'package:http/http.dart' as http;

/// Constants.
const String _defaultMessage = "An unexpected error occurred";

/// Utility class to simplify the use of HTTP errors returned by the backend.
class RepositoryException implements Exception {
  http.Response? raw;
  String message = _defaultMessage;
  int? status;
  int? errorNumber;

  RepositoryException(http.Response errorResponse) {
    raw = errorResponse;

    if (errorResponse.body.isNotEmpty) {
      status = errorResponse.statusCode;
      try {
        // Parse response's body.
        final data = json.decode(errorResponse.body);
        errorNumber = errorResponse.statusCode;
        message = data ?? _defaultMessage;
      } catch (e) {
        // If the body wasn't a JSON object, then must be a plain text error.
        message =
            errorResponse.body.isEmpty ? _defaultMessage : errorResponse.body;
      }
    }
  }

  RepositoryException.err(Exception exp) {
    // Mainly two types of exceptions may occur here:
    // 1. ClientException: Connection closed before full header was received.
    // 2. TypeError: type '(HttpException) => Null' is not a subtype of type '(dynamic) => dynamic'.
    // In both cases we are only interested on the message, not on the full object.
    message = exp.toString();
  }

  bool unauthorized() => status == 401;

  @override
  String toString() => message;
}
