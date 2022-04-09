import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import './modules/wazo_auth.dart';

class WazoClient {
  final String host;
  late final HttpClient _httpClient;

  late IOClient _ioClient;
  BaseClient get client => _ioClient;

  late String token;

  WazoAuth get auth => WazoAuth(this);

  WazoClient(
    this.host,
  ) {
    _httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String localhost, int port) {
        final Uri uri = Uri.parse(host);
        return uri.host == localhost;
      };

    _ioClient = IOClient(_httpClient);
  }

  factory WazoClient.withToken(String host, String token) {
    return _WazoClientToken(host, token);
  }
}

class _WazoClientToken extends WazoClient {
  _WazoClientToken(String host, String token) : super(host) {
    this.token = token;
  }
}
