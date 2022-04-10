import 'package:http/browser_client.dart';

import '../wazo_client.dart';
import 'wazo_base_client.dart';

/// Top Level function to create the [WazoClient] depending on the platform
WazoClient createWazoClient(String host) => WazoClientBrowser(host);

/// Represent a [WazoClient] usable with the browser
class WazoClientBrowser extends WazoBaseClient {
  /// Create a new [WazoClient] from a [host] using a [BrowserClient]
  WazoClientBrowser(String host) : super(host, BrowserClient());
}
