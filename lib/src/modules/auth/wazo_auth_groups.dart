import 'dart:convert';

import '../../wazo_direction.dart';

import '../../wazo_exception.dart';
import '../wazo_module.dart';

/// Represents the `groups` endpoint of the `auth` module.
class WazoAuthGroups extends WazoModule {
  WazoAuthGroups(WazoModule parent) : super.fromParent(parent);

  /// Retrieve the list of groups
  /// [recurse] Should the query include sub-tenants
  /// [order] Name of the field to use for sorting the list of items returned.
  /// [direction] Sort list of items in [WazoDirection.asc] (ascending) or [WazoDirection.desc] (descending) order
  /// [limit] Number of items to return
  /// [offset] Index of the first item to return
  /// [search] Search term for filtering a list of items. Only items with a field containing the search term will be returned
  /// [uuid] The UUID of the group
  /// [name] The name of the group
  /// [userUuid] The UUID of the user
  /// [readOnly] Is the group managed by the system?
  /// [wazoTenant] The tenant's UUID, defining the ownership of a given resource.
  Future<Map<String, dynamic>> getGroups(
      {bool? recurse = false,
      String? order,
      WazoDirection? direction,
      int? limit,
      int? offset = 0,
      String? search,
      String? uuid,
      String? name,
      String? userUuid,
      bool? readOnly,
      String? wazoTenant}) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final queryParameters = {
      'recurse': recurse,
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction.toString()} : null,
      ...?limit != null ? {'limit': limit} : null,
      'offset': offset,
      ...?search != null ? {'search': search} : null,
      ...?uuid != null ? {'uuid': uuid} : null,
      ...?name != null ? {'name': name} : null,
      ...?userUuid != null ? {'user_uuid': userUuid} : null,
      ...?readOnly != null ? {'read_only': readOnly} : null,
    };

    final uri = Uri.parse(
        formatUrl('groups?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
      'Content-Type': 'application/json',
      ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Create a new group
  /// [name] The name of the group
  /// [wazoTenant] The tenant's UUID, defining the ownership of a given resource.
  Future<Map<String, dynamic>> createGroup(String name,
      {String? wazoTenant}) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final uri = Uri.parse(formatUrl('groups'));

    final response = await httpClient.post(uri,
        headers: {
          'Content-Type': 'application/json',
          ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
        },
        body: json.encode({
          'name': name,
        }));

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Delete a group
  /// [groupUuid] The UUID of the group
  /// [wazoTenant] The tenant's UUID, defining the ownership of a given resource.
  Future<bool> deleteGroup(String groupUuid, {String? wazoTenant}) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final uri = Uri.parse(formatUrl('groups/$groupUuid'));

    final response = await httpClient.delete(uri, headers: {
      'Content-Type': 'application/json',
      ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
    });

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the details of a group
  /// [groupUuid] The UUID of the group
  /// [wazoTenant] The tenant's UUID, defining the ownership of a given resource.
  Future<Map<String, dynamic>> getGroup(String groupUuid,
      {String? wazoTenant}) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final uri = Uri.parse(formatUrl('groups/$groupUuid'));

    final response = await httpClient.get(uri, headers: {
      'Content-Type': 'application/json',
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

  /// Modify a group
  /// [groupUuid] The UUID of the group
  /// [name] The new name of the group
  /// [wazoTenant] The tenant's UUID, defining the ownership of a given resource.
  Future<Map<String, dynamic>> updateGroup(String groupUuid, String name,
      {String? wazoTenant}) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final uri = Uri.parse(formatUrl('groups/$groupUuid'));

    final response = await httpClient.put(uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Auth-Token': '$apiToken',
          ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
        },
        body: json.encode({
          'name': name,
        }));

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the list of policies associated to a group
  /// [groupUuid] The UUID of the group
  /// [order] Name of the field to use for sorting the list of items returned.
  /// [direction] Sort list of items in [WazoDirection.asc] (ascending) or [WazoDirection.desc] (descending) order
  /// [limit] Number of items to return
  /// [offset] Index of the first item to return
  /// [search] Search term for filtering a list of items. Only items with a field containing the search term will be returned
  Future<Map<String, dynamic>> getGroupPolicies(
    String groupUuid, {
    String? order,
    WazoDirection? direction,
    int? limit,
    int? offset = 0,
    String? search,
  }) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final queryParameters = {
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction.toString()} : null,
      ...?limit != null ? {'limit': limit} : null,
      'offset': offset,
      ...?search != null ? {'search': search} : null,
    };

    final uri = Uri.parse(formatUrl(
        'groups/$groupUuid/policies?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
      'Content-Type': 'application/json',
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Dissociate a policy from a group
  /// [groupUuid] The UUID of the group
  /// [policyUuid] The UUID of the policy
  Future<bool> dissociateGroupPolicy(
      String groupUuid, String policyUuid) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final uri = Uri.parse(formatUrl('groups/$groupUuid/policies/$policyUuid'));

    final response = await httpClient.delete(uri, headers: {
      'Content-Type': 'application/json',
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Associate a policy to a group
  /// [groupUuid] The UUID of the group
  /// [policyUuid] The UUID of the policy
  Future<bool> associateGroupPolicy(String groupUuid, String policyUuid) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final uri = Uri.parse(formatUrl('groups/$groupUuid/policies/$policyUuid'));

    final response = await httpClient.post(uri, headers: {
      'Content-Type': 'application/json',
      'X-Auth-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the list of users associated to a group
  /// [groupUuid] The UUID of the group
  /// [order] Name of the field to use for sorting the list of items returned.
  /// [direction] Sort list of items in [WazoDirection.asc] (ascending) or [WazoDirection.desc] (descending) order
  /// [limit] Number of items to return
  /// [offset] Index of the first item to return
  /// [search] Search term for filtering a list of items. Only items with a field containing the search term will be returned
  Future<Map<String, dynamic>> getGroupUsers(
    String groupUuid, {
    String? order,
    WazoDirection? direction,
    int? limit,
    int? offset = 0,
    String? search,
  }) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final queryParameters = {
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction.toString()} : null,
      ...?limit != null ? {'limit': limit} : null,
      'offset': offset,
      ...?search != null ? {'search': search} : null,
    };

    final uri = Uri.parse(formatUrl(
        'groups/$groupUuid/users?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(uri, headers: {
      'Content-Type': 'application/json',
      'X-API-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Dissociate a user from a group
  /// [groupUuid] The UUID of the group
  /// [userUuid] The UUID of the user
  Future<bool> dissociateGroupUser(String groupUuid, String userUuid) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final uri = Uri.parse(formatUrl('groups/$groupUuid/users/$userUuid'));

    final response = await httpClient.delete(uri, headers: {
      'Content-Type': 'application/json',
      'X-API-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Associate a user to a group
  /// [groupUuid] The UUID of the group
  /// [userUuid] The UUID of the user
  Future<bool> associateGroupUser(String groupUuid, String userUuid) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }

    final uri = Uri.parse(formatUrl('groups/$groupUuid/users/$userUuid'));

    final response = await httpClient.post(uri, headers: {
      'Content-Type': 'application/json',
      'X-API-Token': '$apiToken',
    });

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
