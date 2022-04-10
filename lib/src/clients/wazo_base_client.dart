import 'package:http/http.dart';

import '../../wazo_dart.dart';
import '../modules/auth/wazo_auth.dart';

/// Base implementation of [WazoClient]
abstract class WazoBaseClient implements WazoClient {
  /// The internal [client] used to connect to the Wazo API
  @override
  Client client;

  /// The [host] of the Wazo API
  @override
  String host;

  /// The [apiToken] used to authenticate to the Wazo API
  @override
  String? apiToken;

  /// Give access to the [WazoAuth] (authd) related methods
  @override
  WazoAuth get auth => WazoAuth(this);

  /// Create a new [WazoClient] from a [host] and [client]
  WazoBaseClient(this.host, this.client);
}
