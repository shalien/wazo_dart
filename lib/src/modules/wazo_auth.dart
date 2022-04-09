import 'dart:convert';

import '../modules/wazo_auth_access_type.dart';
import '/src/wazo_client.dart';

import '../wazo_module.dart';

class WazoAuth extends WazoModule {
  WazoAuth(WazoClient client) : super(client, 'auth', '0.1');

  Future<Map<String, dynamic>> createToken(String username, String password,
      {WazoAuthAccessType accessType = WazoAuthAccessType.online,
      String backend = 'wazo_user',
      String? clientId,
      int expiration = 3600,
      String? refreshToken,
      String? tenantId}) async {
    if (accessType == WazoAuthAccessType.offline && clientId == null) {
      throw ArgumentError('clientId is required when accessType is offline');
    }

    final url = Uri.parse(formatUrl('token'));

    final body = {
      'username': username,
      'password': password,
      'access_type': accessType.toString().split('.').last,
      'backend': backend,
      ...?clientId != null && accessType == WazoAuthAccessType.offline
          ? {'client_id': clientId}
          : null,
      'expiration': expiration,
      ...?refreshToken != null ? {'refresh_token': refreshToken} : null,
      ...?tenantId != null ? {'tenant_id': tenantId} : null,
    };

    final response = await httpClient.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${_generateToken(username, password)}'
        },
        body: jsonEncode(body));

    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      default:
        print(response.body);
        throw Exception('${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> isTokenValid(String token,
      {String? scope, String? tenantId}) async {
    final uri =
        Uri.parse(formatUrl('token/$token?scope=$scope&tenant_id=$tenantId'));

    final response = await httpClient.head(uri);

    switch (response.statusCode) {
      case 204:
        return response.headers;
      default:
        throw Exception('${response.statusCode}');
    }
  }

  String _generateToken(String username, String password) {
    return base64Url.encode(utf8.encode('$username:$password'));
  }
}
