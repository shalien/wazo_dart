import 'dart:convert';

import 'package:http/http.dart' as http;

/// A custom [Exception] to handle error message from the Wazo API
class WazoException implements Exception {
  /// The HTTP [code] returned by the Wazo API
  final int code;

  /// The [details] returned by the Wazo API in the form of a decode json object
  final Map<String, dynamic> details;

  /// Private constructor for the [WazoException]
  WazoException._(this.code, this.details);

  /// Create a new [WazoException] from a [response]
  factory WazoException.fromResponse(http.Response response) {
    return WazoException._(response.statusCode, json.decode(response.body));
  }
}
