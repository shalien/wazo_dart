import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'modules/auth/wazo_auth.dart';

import 'clients/wazo_client_none.dart'
    if (dart.library.io) 'clients/wazo_client_io.dart'
    if (dart.library.html) 'clients/wazo_client_html.dart';

/// Represent a client to connect and interact with the Wazo API
abstract class WazoClient {
  /// The [host] of the Wazo API
  String get host;

  /// The internal [client] used to connect to the Wazo API
  Client get client;

  /// The [apiToken] used to authenticate to the Wazo API
  late String? apiToken;

  /// Give access to the [WazoAuth] (authd) related methods
  WazoAuth get auth;

  /// Create a new [WazoClient] from a [host]
  /// Depending on the platform will create a client using [IOClient] or [BrowserClient]
  factory WazoClient(String host) => createWazoClient(host);
}
