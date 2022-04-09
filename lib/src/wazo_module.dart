import 'package:http/http.dart';
import 'package:wazo_dart/src/wazo_client.dart';

abstract class WazoModule {
  final WazoClient client;
  final String name;
  final String version;
  late BaseClient httpClient;

  WazoModule(this.client, this.name, this.version) {
    httpClient = client.client;
  }

  String formatUrl(String path) {
    return '${client.host}/api/$name/$version/$path';
  }
}
