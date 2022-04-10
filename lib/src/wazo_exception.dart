import 'dart:convert';

import 'package:http/http.dart' as http;

class WazoException implements Exception {
  final int code;
  final Map<String, dynamic> details;

  WazoException._(this.code, this.details);

  factory WazoException.fromResponse(http.Response response) {
    return WazoException._(response.statusCode, json.decode(response.body));
  }
}
