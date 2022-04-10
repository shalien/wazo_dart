import 'dart:io';

import 'package:http/io_client.dart';

import '../wazo_client.dart';
import 'wazo_base_client.dart';

/// Top Level function to create the [WazoClient] depending on the platform
WazoClient createWazoClient(String host) => WazoClientIO(host);

/// Internal [HttpClient] with handling of self signed certificate since the Wazo API
/// use self signed certificate
IOClient _createClient(String host) {
  late final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String localhost, int port) {
      final Uri uri = Uri.parse(host);
      return uri.host == localhost;
    };

  /// Internal [IOClient] build with the custom [HttpClient]
  late final IOClient _innerIOClient = IOClient(_httpClient);

  return _innerIOClient;
}

/// Represent a [WazoClient] usable with the dart:io
class WazoClientIO extends WazoBaseClient {
  /// Create a new [WazoClient] from a [host] using a [IOClient]
  WazoClientIO(String host) : super(host, _createClient(host));
}
