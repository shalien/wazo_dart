import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';

class WazoCalldFaxes extends WazoModule {
  WazoCalldFaxes(WazoModule parent) : super.fromParent(parent);

  /// Send a fax
  /// [context] of the recipient of the fax
  /// [extension] of the recipient of the fax
  /// [callerId] that will be presented to the recipient of the fax.
  /// Example: "my-name <+15551112222>".
  /// Default: "Wazo Fax"
  /// Extension to compose before sending fax. Useful for fax in IVR
  /// Time waiting before sending fax when destination has answered (in seconds)
  Future<Map<String, dynamic>> sendFax(
      String context, String extension, String content,
      {String? callerId = "Wazo Fax",
      String? ivrExtension,
      int? waitTime}) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = {
      'context': context,
      'extension': extension,
      'caller_id': callerId,
      ...?ivrExtension != null ? {'ivr_extension': ivrExtension} : null,
      ...?waitTime != null ? {'wait_time': waitTime} : null,
    };

    final uri = Uri.parse(
        formatUrl('/faxes?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/pdf',
        'X-Auth-Token': '$apiToken',
      },
      body: content,
    );

    switch (response.statusCode) {
      case 201:
        return json.decode(response.body);
      case 400:
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  // Users related methods
}
