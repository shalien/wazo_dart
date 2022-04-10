import 'dart:convert';

import 'package:wazo_dart/src/modules/auth/wazo_direction.dart';
import 'package:wazo_dart/src/modules/auth/wazo_session_type.dart';
import 'package:wazo_dart/src/modules/auth/wazo_user_purpose.dart';
import 'package:wazo_dart/wazo_dart.dart';

import 'wazo_auth_access_type.dart';

import '../wazo_module.dart';
import 'wazo_email_address.dart';

class WazoAuth extends WazoModule {
  WazoAuth(WazoClient client) : super(client, 'auth', '0.1');

  /* Admin */
  /* https://wazo-platform.org/documentation/api/authentication.html#tag/users/paths/~1admin~1users~1{user_uuid}~1emails/put */
  /// Update all of the users ([userUuid]) email address ([WazoEmailAddress]) at the same time.
  /// If an existing address is missing from the list, it will be removed.
  /// An empty [list] will remove all addresses.
  /// If [addresses] are defined, one and only one address should be [WazoEmailAddress.main].
  /// If the [WazoEmailAddress.confirmed] field is set to none or omitted the existing value will be reused if it exists, otherwise the address will not be confirmed.
  Future<List<String>> updateEmailAddress(
      String userUuid, List<WazoEmailAddress> addresses) async {
    if (token == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('/admin/users/$userUuid/emails'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$token',
      },
      body: json.encode(
        addresses.map((address) => address.toJson()).toList(),
      ),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body) as List<String>;
      case 404:
        throw WazoException.fromResponse(response);
    }

    return json
        .decode(response.body)
        .map<String>((address) => address['address'])
        .toList();
  }

  /* Users */
  /// Retrieve the list of users.
  /// [order] is the field to order the results by, can be [username], [firstname] or [lastname].
  /// [direction] is the direction to order the results by, can be [asc] or [desc].
  /// [recurse] is a boolean to indicate if the results should be recursively retrieved inside subtenants.
  /// [limit] is the maximum number of results to return.
  /// [offset] is the offset to start the results from.
  /// [search] is a string to search for in the results.
  Future<Map<String, dynamic>> getUsers(
      {String? order,
      WazoDirection? direction,
      int limit = 0,
      int offset = 0,
      String? search,
      bool recurse = false,
      String? wazoTenant}) async {
    if (token == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = <String, String>{};

    if (order != null) {
      queryParameters['order'] = order;
    }

    if (direction != null) {
      queryParameters['direction'] = direction.toString().split('.').last;
    }

    queryParameters['limit'] = limit.toString();
    queryParameters['offset'] = offset.toString();

    if (search != null) {
      queryParameters['search'] = search;
    }

    queryParameters['recurse'] = recurse.toString();

    final uri = Uri.parse(
        formatUrl('/users?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(
      uri,
      headers: {
        'X-Auth-Token': '$token',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
    );

    print(response.body);

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Creates a new user that can be used to retrieve a token.
  /// The UUID can be used to link this user the a wazo-confd user by using the same UUID
  /// [username] is the username of the user.
  /// [password] is the password of the user.
  /// [firstname] is the firstname of the user.
  /// [lastname] is the lastname of the user.
  /// [email] is the email of the user.
  /// [wazoTenant] is the tenant of the user.
  /// [uuid] must be a valid format UUID.
  /// [purpose] can either be [WazoUserPurpose.user], [WazoUserPurpose.internal] or [WazoUserPurpose.externalApi].
  Future<Map<String, dynamic>> createUser(
      String emailAddress,
      String firstname,
      String lastname,
      String password,
      WazoUserPurpose purpose,
      String username,
      String uuid,
      {bool enabled = true,
      String? wazoTenant}) async {
    if (token == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$token',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
      body: json.encode({
        'email_address': emailAddress,
        'firstname': firstname,
        'lastname': lastname,
        'password': password,
        'purpose': purpose.toString(),
        'username': username,
        'uuid': uuid,
        'enabled': enabled,
      }),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// This action will send an email containing instructions to set a new password.
  /// The [username] **or** [email] address should be supplied as query string to find the user
  /// [username] is the username of the user.
  /// [email] is the email of the user.
  Future<bool> resetUserPassword({String? username, String? email}) async {
    if (email == null && username == null) {
      throw ArgumentError('Either username or email must be supplied');
    } else if (email != null && username != null) {
      throw ArgumentError('Only one of username or email can be supplied');
    }

    final queryParameters = <String, String>{
      ...?username != null && email == null ? {'username': username} : null,
      ...?email != null && username == null ? {'email': email} : null,
    };

    final uri = Uri.parse(formatUrl(
        '/users/password/reset?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri);

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Set a new [password] for the user after the [userUuid] used the GET on the reset URL
  Future<bool> setUserPassword(String userUuid, String password) async {
    if (token == null) {
      throw ArgumentError('No token available');
    }

    final uri =
        Uri.parse(formatUrl('/users/password/reset/?user_uuid=$userUuid'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$token',
      },
      body: json.encode({'password': password}),
    );

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Creates a new user that can be used to retrieve a token.
  /// [emailAddress] is the email address of the user.
  /// [firstname] is the firstname of the user.
  /// [lastname] is the lastname of the user.
  /// [password] is the password of the user.
  /// [username] is the username of the user.
  Future<Map<String, dynamic>> registerUser(
      String emailAddress, String password, String username,
      {String? firstname, String? lastname}) async {
    if (token == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/register'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email_address': emailAddress,
        ...?firstname != null ? {'firstname': firstname} : null,
        ...?lastname != null ? {'lastname': lastname} : null,
        'password': password,
        'username': username,
      }),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Finds all of a user's refresh token and return the list. Access tokens are not included in the result.
  /// Doing a query with the [user_uuid] [me] will result in the current user's token being used.
  Future<Map<String, dynamic>> getUserRefreshTokenList(String userUuidOrMe,
      {String? order,
      WazoDirection? direction,
      int? limit,
      int? offset = 0,
      String? search,
      String? wazoTenant}) async {
    if (token == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(
        formatUrl('/users/$userUuidOrMe/refresh_tokens?${encodeQueryParameters({
          ...?order != null ? {'order': order} : null,
          ...?direction != null ? {'direction': direction.toString()} : null,
          ...?limit != null ? {'limit': limit} : null,
          ...?offset != null ? {'offset': offset} : null,
          ...?search != null ? {'search': search} : null,
        })}'));

    final response = await httpClient.get(uri, headers: {
      'X-Auth-Token': '$token',
      ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Remove a given refresh token. This only prevent this refresh token from creating new access tokens. Any tokens that are currently issued are still usable and should be revoked if needed.
  Future<bool> deleteUserRefreshToken(
      String userUuidOrMe, String clientId) async {
    if (token == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuidOrMe/tokens/$clientId'));

    final response = await httpClient.delete(uri, headers: {
      'X-Auth-Token': '$token',
    });

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

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
