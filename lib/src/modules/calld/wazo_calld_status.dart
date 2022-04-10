import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';

/// Represents the `status` endpoint of the `calld` module.
class WazoCalldStatus extends WazoModule {
  WazoCalldStatus(WazoModule? parent) : super.fromParent(parent);

  ///Print infos about internal status of wazo-calld
  Future<Map<String, dynamic>> getStatus() async {
    if (apiToken == null) {
      throw ArgumentError('Api token is required');
    }

    final uri = Uri.parse(formatUrl('status'));

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
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
