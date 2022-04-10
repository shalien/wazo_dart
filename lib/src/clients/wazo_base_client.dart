import 'package:http/http.dart';

import '../../wazo_dart.dart';
import '../modules/auth/wazo_auth.dart';

/// Base implementation of [WazoClient]
abstract class WazoBaseClient implements WazoClient {
  /// The internal [client] used to connect to the Wazo API
  @override
  Client get client => _client;

  /// The internal [_client] used to connect to the Wazo API
  final Client _client;

  /// The [host] of the Wazo API
  @override
  String get host => _host;

  /// The [_host] of the Wazo API
  final String _host;

  /// The [apiToken] used to authenticate to the Wazo API
  @override
  String? apiToken;

  /// Give access to the [WazoAuth] authd module methods and endpoints
  @override
  WazoAuth get auth => WazoAuth(this);

  /// Create a new [WazoClient] from a [host] and [client]
  WazoBaseClient(this._host, this._client);
}
