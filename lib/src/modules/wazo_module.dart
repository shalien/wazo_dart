import 'package:http/http.dart';
import 'package:wazo_dart/src/wazo_client.dart';

abstract class WazoModule {
  final WazoClient wazoClient;
  WazoModule? parent;
  final String name;
  final String version;
  late Client httpClient;

  String? get token => wazoClient.token;
  String get host => wazoClient.host;

  WazoModule(this.wazoClient, this.name, this.version, {this.parent}) {
    httpClient = wazoClient.client;
  }

  String formatUrl(String path) {
    return '$host/api/$name/$version/$path';
  }

  String encodeQueryParameters(Map<String, dynamic> queryParameters) {
    return queryParameters.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
  }
}
