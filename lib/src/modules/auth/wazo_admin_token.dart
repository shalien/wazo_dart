import 'dart:convert';

import '../../../auth.dart';
import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'wazo_session_type.dart';

class WazoAuthToken extends WazoModule {
  WazoAuthToken(WazoModule parent) : super.fromParent(parent);

  Future<Map<String, dynamic>> createToken(String username, String password,
      {WazoAuthAccessType accessType = WazoAuthAccessType.online,
      String backend = 'wazo_user',
      String? clientId,
      int expiration = 3600,
      String? refreshToken,
      String? tenantId,
      WazoSessionType sessionType = WazoSessionType.desktop}) async {
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
          'Authorization': 'Basic ${_generateToken(username, password)}',
          'Wazo-Session-Type': sessionType.toString().split('.').last,
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

  Future<bool> isTokenValid(String token,
      {String? scope, String? tenantId}) async {
    final parameters = <String, dynamic>{
      ...?scope != null ? {'scope': scope} : null,
      ...?tenantId != null ? {'tenant_id': tenantId} : null,
    };

    final uri = Uri.parse(formatUrl(
        'token/$token?${parameters.entries.map((e) => '${e.key}=${e.value}').join('&')}'));

    final response = await httpClient.head(uri);

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  String _generateToken(String username, String password) {
    return base64Url.encode(utf8.encode('$username:$password'));
  }
}
