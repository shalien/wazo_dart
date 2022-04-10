import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'config/wazo_config_patch.dart';

/// Represents the `config` endpoint of the `auth` module.
class WazoAuthConfig extends WazoModule {
  WazoAuthConfig(WazoModule parent) : super.fromParent(parent);

  /// Show the current configuration
  Future<Map<String, dynamic>> getConfig() async {
    final uri = Uri.parse(formatUrl('config'));

    final response = await httpClient.get(uri, headers: {
      'Content-Type': 'application/json',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Update the current configuration.
  /// Changes are not persistent across service restart.
  /// [patches] is a list of [WazoConfigPatch]
  /// [WazoConfigPatch.op] Patch operation. Supported operations: `replace`.
  /// [WazoConfigPatch.path] JSON path to operate on. Supported paths: `/debug`.
  /// [WazoConfigPatch.value] The new value for the operation. Type of value is dependent of [WazoConfigPatch.path]
  Future<Map<String, dynamic>> updateConfig(
      List<WazoConfigPatch> patches) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('config'));

    final response = await httpClient.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode(patches.map((patch) => patch.toJson()).toList()),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
