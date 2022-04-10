import 'dart:io';

import 'package:http/io_client.dart';

import '../wazo_client.dart';
import 'wazo_base_client.dart';

WazoClient createWazoClient(String host) => WazoClientIO(host);

IOClient _createClient(String host) {
  late final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String localhost, int port) {
      final Uri uri = Uri.parse(host);
      return uri.host == localhost;
    };

  late final IOClient _innerIOClient = IOClient(_httpClient);

  return _innerIOClient;
}

class WazoClientIO extends WazoBaseClient {
  WazoClientIO(String host) : super(host, _createClient(host));
}
