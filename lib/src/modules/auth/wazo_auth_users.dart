import 'dart:convert';

import 'wazo_auth_groups.dart';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import '../../wazo_direction.dart';
import 'users/wazo_user_email_address.dart';
import 'users/wazo_user_purpose.dart';
import 'wazo_auth.dart';

/// Represents the `users` endpoint of the `auth` module.
class WazoAuthUsers extends WazoModule {
  WazoAuthUsers(WazoModule parent) : super.fromParent(parent);

  /// Imported from [WazoAuthAdmin.updateAdminEmailAddress]
  /// Update all of the users ([userUuid]) email address ([WazoUserEmailAddress]) at the same time.
  /// If an existing address is missing from the list, it will be removed.
  /// An empty list will remove all addresses.
  /// If [addresses] are defined, one and only one address should be [WazoUserEmailAddress.main].
  /// If the [WazoUserEmailAddress.confirmed] field is set to none or omitted the existing value will be reused if it exists, otherwise the address will not be confirmed.
  Future<Map<String, dynamic>> updateAdminEmailAddress(
          String userUuid, List<WazoUserEmailAddress> addresses) async =>
      (parent as WazoAuth).admin.updateAdminEmailAddress(userUuid, addresses);

  /// Imported from [WazoAuthGroups.dissociateGroupUser]
  /// Dissociate a user from a group
  /// [groupUuid] The UUID of the group
  /// [userUuid] The UUID of the user
  Future<bool> dissociateGroupUser(String groupUuid, String userUuid) async =>
      (parent as WazoAuth).groups.dissociateGroupUser(groupUuid, userUuid);

  /// Imported from [WazoAuthGroups.associateGroupUser]
  /// Associate a user to a group
  /// [groupUuid] The UUID of the group
  /// [userUuid] The UUID of the user
  Future<bool> associateGroupUser(String groupUuid, String userUuid) async =>
      (parent as WazoAuth).groups.associateGroupUser(groupUuid, userUuid);

  /// Retrieve the list of users.
  /// [order] is the field to order the results by, can be username, firstname or lastname.
  /// [direction] is the direction to order the results by, can be [WazoDirection] or [WazoDirection.desc].
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
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = <String, String>{};

    if (order != null) {
      queryParameters['order'] = order;
    }

    if (direction != null) {
      queryParameters['direction'] = direction.toString();
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
        'X-Auth-Token': '$apiToken',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
    );

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
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
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
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri =
        Uri.parse(formatUrl('/users/password/reset/?user_uuid=$userUuid'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
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
    if (apiToken == null) {
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
  /// Doing a query with the [userUuidOrMe] me will result in the current user's token being used.
  Future<Map<String, dynamic>> getUserRefreshTokenList(String userUuidOrMe,
      {String? order,
      WazoDirection? direction,
      int? limit,
      int? offset = 0,
      String? search,
      String? wazoTenant}) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = {
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction.toString()} : null,
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
      ...?search != null ? {'search': search} : null,
    };

    final uri = Uri.parse(formatUrl(
        '/users/$userUuidOrMe/refresh_tokens?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
      'X-Auth-Token': '$apiToken',
      ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Remove a given refresh token.
  /// This only prevent this refresh token from creating new access tokens.
  /// Any tokens that are currently issued are still usable and should be revoked if needed.
  Future<bool> deleteUserRefreshToken(
      String userUuidOrMe, String clientId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuidOrMe/tokens/$clientId'));

    final response = await httpClient.delete(uri, headers: {
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Delete an user by [userUuid].
  Future<bool> deleteUser(String userUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuid'));

    final response = await httpClient.delete(uri, headers: {
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the details of a user by [userUuid].
  Future<Map<String, dynamic>> getUser(String userUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuid'));

    final response = await httpClient.get(uri, headers: {
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Update an existing user by [userUuid].
  Future<Map<String, dynamic>> updateUser(String userUuid,
      {bool? enabled,
      String? firstname,
      String? lastname,
      WazoUserPurpose? purpose,
      String? username}) async {
    final uri = Uri.parse(formatUrl('/users/$userUuid'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode({
        ...?enabled != null ? {'enabled': enabled} : null,
        ...?firstname != null ? {'firstname': firstname} : null,
        ...?lastname != null ? {'lastname': lastname} : null,
        ...?purpose != null ? {'purpose': purpose.toString()} : null,
        ...?username != null ? {'username': username} : null,
      }),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Update all of the users email address at the same time.
  /// If an existing address is missing from the list, it will be removed.
  /// An empty list will remove all addresses.
  /// If addresses are defined, one and only one address should be main.
  /// All new address are created unconfirmed.
  Future<Map<String, dynamic>> updateUserEmailAddress(
      String userUuid, List<WazoUserEmailAddress> emails) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuid/emails'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode({
        'emails': emails.map((email) => email.toJson()).toList(),
      }),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Ask a new confirmation email
  Future<bool> askNewConfirmationEmail(
      String userUuid, String emailUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri =
        Uri.parse(formatUrl('/users/$userUuid/emails/$emailUuid/confirm'));

    final response = await httpClient.get(uri, headers: {
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 204:
      case 409:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the list of the users external auth data
  /// This list should not contain any sensible information
  Future<Map<String, dynamic>> getUserExternalAuthData(
    String userUuid, {
    String? order,
    WazoDirection? direction,
    int? limit,
    int? offset = 0,
    String? search,
  }) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = {
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction.toString()} : null,
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
      ...?search != null ? {'search': search} : null,
    };

    final uri = Uri.parse(formatUrl(
        '/users/$userUuid/external?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the list of groups associated to a user
  Future<Map<String, dynamic>> getUserGroup(
    String userUuid, {
    String? order,
    WazoDirection? direction,
    int? limit,
    int? offset = 0,
    String? search,
  }) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = {
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction.toString()} : null,
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
      ...?search != null ? {'search': search} : null,
    };

    final uri = Uri.parse(formatUrl(
        '/users/$userUuid/groups?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Change the user's password
  Future<bool> changeUserPassword(
      String userUuid, String newPassword, String oldPassword) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuid/password'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode({
        'new_password': newPassword,
        'old_password': oldPassword,
      }),
    );

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the list of policies associated to a user
  Future<Map<String, dynamic>> getUserPolicies(
    String userUuid, {
    String? order,
    WazoDirection? direction,
    int? limit,
    int? offset = 0,
    String? search,
  }) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = {
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction.toString()} : null,
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
      ...?search != null ? {'search': search} : null,
    };

    final uri = Uri.parse(formatUrl(
        '/users/$userUuid/policies?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Dissociate a policy from a user
  /// [userUuid] The UUID of the user to dissociate
  /// [policyUuid] The UUID of the policy to dissociate
  Future<bool> dissociatePolicyFromUser(
      String policyUuid, String userUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuid/policies/$policyUuid'));

    final response = await httpClient.delete(
      uri,
      headers: {
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Associate a policy to a user
  /// [userUuid] The UUID of the user to associate
  /// [policyUuid] The UUID of the policy to associate
  Future<bool> associatePolicyToUser(String policyUuid, String userUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuid/policies/$policyUuid'));

    final response = await httpClient.put(
      uri,
      headers: {
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the list of sessions associated to a user
  Future<Map<String, dynamic>> getUserSessions(String userUuid,
      {int? limit, int? offset = 0, String? wazoTenant}) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = {
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
    };

    final uri = Uri.parse(formatUrl(
        '/users/$userUuid/sessions?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
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
  Future<bool> deleteUserSession(String userUuid, String sessionUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/users/$userUuid/sessions/$sessionUuid'));

    final response = await httpClient.delete(
      uri,
      headers: {
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return Future.value(true);
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
