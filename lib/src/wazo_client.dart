import 'package:http/http.dart';
import 'modules/auth/wazo_auth.dart';

import 'clients/wazo_client_none.dart'
    if (dart.library.io) 'clients/wazo_client_io.dart'
    if (dart.library.html) 'clients/wazo_client_html.dart';

abstract class WazoClient {
  late final String host;
  late final Client client;
  late String? apiToken;

  WazoAuth get auth;

  factory WazoClient(String host) => createWazoClient(host);
}
