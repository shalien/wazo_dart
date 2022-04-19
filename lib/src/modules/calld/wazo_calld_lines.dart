import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';

class WazoCalldLines extends WazoModule {
  WazoCalldLines.fromParent(WazoModule parent) : super.fromParent(parent);

  /// List line endpoint statuses
  /// List the status of line endpoints that are configured on Asterisk
  /// Supported technologies: SIP
  /// Lines with unsupported technologies will be listed but there status will be null
  Future<Map<String, dynamic>> getLinesStatus() async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/lines'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
