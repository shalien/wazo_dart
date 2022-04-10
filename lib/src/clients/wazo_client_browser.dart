import 'package:http/browser_client.dart';

import '../wazo_client.dart';
import 'wazo_base_client.dart';

WazoClient createWazoClient(String host) => WazoClientBrowser(host);

class WazoClientBrowser extends WazoBaseClient {
  WazoClientBrowser(String host) : super(host, BrowserClient());
}
