import 'package:http/http.dart';
import '../wazo_client.dart';

/// Represent a module of the Wazo API
/// Each module is then separated by endpoints
abstract class WazoModule {
  /// The [WazoClient] used to connect to the Wazo API
  final WazoClient wazoClient;

  /// The [name] of the module
  final String name;

  /// The [version] of the module
  final String version;

  /// Get the [Client] from the [WazoClient]
  late Client httpClient;

  /// Used to create the submodules and linked them to the parent module
  late WazoModule parent;

  /// Shortcut to get the [apiToken] from the [WazoClient]
  String? get apiToken => wazoClient.apiToken;

  /// Shortcut to get the [host] from the [WazoClient]
  String get host => wazoClient.host;

  /// Create a [WazoModule] representing a part of the Wazo API
  /// [wazoClient] The [WazoClient] used to connect to the Wazo API
  /// [name] The [name] of the module
  /// [version] The [version] of the module
  WazoModule(this.wazoClient, this.name, this.version) {
    httpClient = wazoClient.client;
  }

  /// Create a submodule from a [WazoModule], representing a endpoint of the Wazo API
  WazoModule.fromParent(this.parent)
      : wazoClient = parent.wazoClient,
        name = parent.name,
        version = parent.version;

  /// Format the [url] with the [name] and [version] of the module
  String formatUrl(String path) {
    return '$host/api/$name/$version/$path';
  }

  /// Encode the parameters for usage in the  requests
  String encodeQueryParameters(Map<String, dynamic> queryParameters) {
    return queryParameters.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
  }
}
