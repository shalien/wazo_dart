import 'package:http/http.dart';

import '../../wazo_dart.dart';
import '../modules/auth/wazo_auth.dart';

class WazoBaseClient implements WazoClient {
  @override
  Client client;

  @override
  String host;

  @override
  String? token;

  @override
  WazoAuth get auth => WazoAuth(this);

  WazoBaseClient(this.host, this.client);
}
