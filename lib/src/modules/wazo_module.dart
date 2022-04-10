import 'package:http/http.dart';
import '../wazo_client.dart';

abstract class WazoModule {
  final WazoClient wazoClient;
  final String name;
  final String version;
  late Client httpClient;
  late WazoModule parent;

  String? get apiToken => wazoClient.apiToken;
  String get host => wazoClient.host;

  WazoModule(this.wazoClient, this.name, this.version) {
    httpClient = wazoClient.client;
  }

  WazoModule.fromParent(this.parent)
      : wazoClient = parent.wazoClient,
        name = parent.name,
        version = parent.version;

  String formatUrl(String path) {
    return '$host/api/$name/$version/$path';
  }

  String encodeQueryParameters(Map<String, dynamic> queryParameters) {
    return queryParameters.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
  }
}
