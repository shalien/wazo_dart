import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'wazo_auth.dart';

/// Represents the `sessions` endpoint of the `auth` module.
class WazoAuthSessions extends WazoModule {
  WazoAuthSessions(WazoModule parent) : super.fromParent(parent);

  /// List sessions
  /// [recurse] Should the query include sub-tenants
  /// [limit] The limit defines the number of individual objects that are returned
  /// [offset] The offset defines the number of individual objects that are skipped
  Future<Map<String, dynamic>> getSessions(
      {bool? recurse = false,
      int? limit,
      int? offset = 0,
      String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final queryParameters = {
      ...?recurse != null ? {'recurse': recurse} : null,
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
    };

    final uri = Uri.parse(
        formatUrl('sessions?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
      'Content-Type': 'application/json',
      'X-Auth-Token': '$apiToken',
      ...?wazoTenant != null ? {'X-Wazo-Tenant': wazoTenant} : null,
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Delete a session
  /// [sessionUuid] The session id
  Future<bool> deleteSession(String sessionUuid) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('sessions/$sessionUuid'));

    final response = await httpClient.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Imported from [WazoAuthUsers.getUserSessions]
  /// Retrieves the list of sessions associated to a user
  /// [limit] The limit defines the number of individual objects that are returned
  /// [offset] The offset defines the number of individual objects that are skipped
  Future<Map<String, dynamic>> getUserSession(String userUuid,
          {int? limit, int? offset = 0, String? wazoTenant}) async =>
      (parent as WazoAuth).users.getUserSessions(userUuid,
          limit: limit, offset: offset, wazoTenant: wazoTenant);

  /// Imported from [WazoAuthUsers.deleteUserSession]
  /// Delete the session [sessionUuid] for the given [userUuid]
  /// [sessionUuid] The session id
  /// [userUuid] The user id
  Future<bool> deleteUserSession(String userUuid, String sessionUuid) async =>
      (parent as WazoAuth).users.deleteUserSession(userUuid, sessionUuid);
}
