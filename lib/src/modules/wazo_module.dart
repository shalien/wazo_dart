import 'package:http/http.dart';
import '../wazo_client.dart';

/// Represent a module of the Wazo API
/// Each module is then separated by endpoints
abstract class WazoModule {
  /// The [WazoClient] used to connect to the Wazo API
  WazoClient get wazoClient => _wazoClient;

  /// The [WazoClient] used to connect to the Wazo API
  final WazoClient _wazoClient;

  /// The [name] of the module
  final String name;

  /// The [version] of the module
  final String version;

  /// Get the [Client] from the [WazoClient]
  final Client _httpClient;

  /// Get the [Client] from the [WazoClient]
  Client get httpClient => _httpClient;

  /// Used to create the submodules and linked them to the parent module
  final WazoModule? _parent;

  /// Used to create the submodules and linked them to the parent module
  WazoModule? get parent => _parent;

  /// Shortcut to get the [apiToken] from the [WazoClient]
  String? get apiToken => wazoClient.apiToken;

  /// Shortcut to get the [host] from the [WazoClient]
  String get host => wazoClient.host;

  /// Create a [WazoModule] representing a part of the Wazo API
  /// [wazoClient] The [WazoClient] used to connect to the Wazo API
  /// [name] The [name] of the module
  /// [version] The [version] of the module
  WazoModule(this._wazoClient, this.name, this.version)
      : _httpClient = _wazoClient.client,
        _parent = null;

  /// Create a submodule from a [WazoModule], representing a endpoint of the Wazo API
  WazoModule.fromParent(this._parent)
      : _wazoClient = _parent!.wazoClient,
        name = _parent.name,
        version = _parent.version,
        _httpClient = _parent._httpClient;

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
