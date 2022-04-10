import 'dart:convert';

import '../../wazo_direction.dart';
import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'token/wazo_token_access_type.dart';
import 'token/wazo_token_session_type.dart';
import 'wazo_auth.dart';

/// Represents the `token` endpoint of the `auth` module.
class WazoAuthToken extends WazoModule {
  WazoAuthToken(WazoModule parent) : super.fromParent(parent);

  /// Creates a valid token for the supplied [username] and [password] combination or [refreshToken] using the specified [backend].
  /// The user's email address can be used instead of the [username] if the email address is confirmed.
  /// The stock backends are: `wazo_user`, `ldap_user`.
  /// Creating a token with the access_type [WazoTokenAccessType.offline] will also create a refresh token which can be used to create a new token without specifying the [username] and [password].
  /// The [username]/[password] and [refreshToken] method of authentication are mutually exclusive
  /// For more details about the backends, see [the documentation](http://documentation.wazo.community/en/latest/system/wazo-auth/stock_plugins.html#backends-plugins)
  /// [accessType] indicates whether your application can refresh the tokens when the user is not present at the browser.
  /// Valid parameter values are [WazoTokenAccessType.online], which is the default value, and [WazoTokenAccessType.offline]
  /// Only one refresh token will be created for a given user with a given [clientId].
  /// The old refresh for [clientId] will be revoked when creating a new one.
  /// The [clientId] field is required when using the [accessType] [WazoTokenAccessType.offline].
  /// [backend] Default: "wazo_user"
  /// [clientId] is used in conjunction with the [accessType] [WazoTokenAccessType.offline] to known for which application a refresh token has been emitted.
  /// Required when using [accessType]: [WazoTokenAccessType.offline]
  /// [expiration] is the time in seconds after which the token will expire.
  /// [refreshToken] can be used to get a new access token without using the [username]/[password]. This is useful for client application that should not store the [username] and [password] once the user has logged in a first time.
  /// [tenantId] is the tenant identifier (uuid or slug) in which the token should be created. This is useful only in cases where the [backend] used is external, i.e not `wazo_user`.
  /// [sessionType] is the type of session that the token should be created for.
  Future<Map<String, dynamic>> createToken(String username, String password,
      {WazoTokenAccessType accessType = WazoTokenAccessType.online,
      String backend = 'wazo_user',
      String? clientId,
      int expiration = 3600,
      String? refreshToken,
      String? tenantId,
      WazoTokenSessionType sessionType = WazoTokenSessionType.desktop}) async {
    if (accessType == WazoTokenAccessType.offline && clientId == null) {
      throw ArgumentError('clientId is required when accessType is offline');
    }

    final url = Uri.parse(formatUrl('token'));

    final body = {
      'username': username,
      'password': password,
      'access_type': accessType.toString().split('.').last,
      'backend': backend,
      ...?clientId != null && accessType == WazoTokenAccessType.offline
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
        body: json.encode(body));

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        print(response.body);
        throw Exception('${response.statusCode} ${response.reasonPhrase}');
    }
  }

  /// Revoke a token
  /// [token] is the token to revoke
  Future<bool> revokeToken(String token) async {
    final url = Uri.parse(formatUrl('token/$token'));

    final response = await httpClient.delete(url, headers: {
      'Content-Type': 'application/json',
    });

    switch (response.statusCode) {
      case 200:
        return true;
      default:
        print(response.body);
        throw Exception('${response.statusCode} ${response.reasonPhrase}');
    }
  }

  /// Retrieves [token] data
  /// Checks if a [token] is valid in a given context and return the [token] data.
  /// If a [scope] is given, the [token] must have the necessary permissions for the ACL.
  /// If a [tenant] is given, the [token] must have that tenant in its sub-tenant subtree.
  /// The [token] to query
  /// The [scope] to check
  /// A [tenant] UUID to check against
  Future<Map<String, dynamic>> getToken(String token,
      {String? scope, String? tenant}) async {
    final queryParameters = {
      ...?scope != null ? {'scope': scope} : null,
      ...?tenant != null ? {'tenant': tenant} : null,
    };

    final url = Uri.parse(
        formatUrl('token/$token?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(url, headers: {
      'Content-Type': 'application/json',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        print(response.body);
        throw Exception('${response.statusCode} ${response.reasonPhrase}');
    }
  }

  /// Checks if a [token] is valid in a given context.
  /// If a [scope] is given, the [token] must have the necessary permissions for the ACL.
  /// If a [tenant] is given, the [token] must have that tenant in its sub-tenant subtree.
  /// The [token] to query
  /// The [scope] to check
  /// A [tenant] UUID to check against
  Future<bool> isTokenValid(String token,
      {String? scope, String? tenant}) async {
    final parameters = <String, dynamic>{
      ...?scope != null ? {'scope': scope} : null,
      ...?tenant != null ? {'tenant': tenant} : null,
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

  /// Checks if a [token] is valid for given [scopes].
  /// If [tenantUuid] is provided, also checks the [token] against this tenant
  Future<Map<String, dynamic>> checkTokenScopes(
      String token, List<String> scopes,
      {String? tenantUuid}) async {
    final url = Uri.parse(formatUrl('token/$token/scopes'));

    final response = await httpClient.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'scopes': scopes,
          ...?tenantUuid != null ? {'tenant_uuid': tenantUuid} : null,
        }));

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        print(response.body);
        throw Exception('${response.statusCode} ${response.reasonPhrase}');
    }
  }

  /// Finds all refresh tokens and return the list.
  /// Access tokens are not included in the result.
  /// [order] Name of the field to use for sorting the list of items returned.
  /// [direction] Sort list of items in [WazoDirection.asc] (ascending) or [WazoDirection.desc] (descending) order
  /// [limit] Number of items to return
  /// [offset] Index of the first item to return
  /// [search] Search term for filtering a list of items. Only items with a field containing the search term will be returned
  Future<Map<String, dynamic>> getTokens(
      {bool? recurse = false,
      String? order,
      WazoDirection? direction,
      int? limit,
      int? offset = 0,
      String? search,
      String? wazoTenant}) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final queryParameters = {
      ...?recurse != null ? {'recurse': recurse} : null,
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction.toString()} : null,
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
      ...?search != null ? {'search': search} : null,
      ...?wazoTenant != null ? {'wazo_tenant': wazoTenant} : null,
    };

    final url = Uri.parse(
        formatUrl('tokens?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(url, headers: {
      'Content-Type': 'application/json',
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        print(response.body);
        throw Exception('${response.statusCode} ${response.reasonPhrase}');
    }
  }

  /// Imported from [WazoAuthUsers.getUserRefreshTokenList]
  /// Finds all of a user's refresh token and return the list. Access tokens are not included in the result.
  /// Doing a query with the [userUuidOrMe] me will result in the current user's token being used.
  Future<Map<String, dynamic>> getUserRefreshTokenList(String userUuidOrMe,
          {String? order,
          WazoDirection? direction,
          int? limit,
          int? offset = 0,
          String? search,
          String? wazoTenant}) async =>
      (parent as WazoAuth).users.getUserRefreshTokenList(
            userUuidOrMe,
            order: order,
            direction: direction,
            limit: limit,
            offset: offset,
            search: search,
            wazoTenant: wazoTenant,
          );

  /// Imported from [WazoAuthUsers.deleteUserRefreshToken]
  /// Finds all refresh tokens and return the list
  /// Remove a given refresh token.
  /// This only prevent this refresh token from creating new access tokens.
  /// Any tokens that are currently issued are still usable and should be revoked if needed.
  Future<bool> deleteUserRefreshToken(
          String userUuidOrMe, String clientId) async =>
      (parent as WazoAuth).users.deleteUserRefreshToken(userUuidOrMe, clientId);

  /// Encode the [username] and [password] in a base64 string
  String _generateToken(String username, String password) {
    return base64Url.encode(utf8.encode('$username:$password'));
  }
}
