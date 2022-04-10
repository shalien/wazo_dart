import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'wazo_auth.dart';
import '../../wazo_direction.dart';

class WazoAuthPolicies extends WazoModule {
  WazoAuthPolicies(WazoModule parent) : super.fromParent(parent);

  Future<bool> dissociateGroupPolicy(
          String groupUuid, String policyUuid) async =>
      (parent as WazoAuth).groups.dissociateGroupPolicy(groupUuid, policyUuid);

  Future<bool> associateGroupPolicy(
          String groupUuid, String policyUuid) async =>
      (parent as WazoAuth).groups.associateGroupPolicy(groupUuid, policyUuid);

  /// Get a list of all the policies
  /// [order] Name of the field to use for sorting the list of items returned.
  /// [direction] Sort list of items in [WazoDirection.asc] (ascending) or [WazoDirection.desc] (descending) order
  /// [limit] Number of items to return
  /// [offset] Index of the first item to return
  /// [search] Search term for filtering a list of items. Only items with a field containing the search term will be returned
  /// [recurse] Should the query include sub-tenants
  Future<Map<String, dynamic>> getPolicies({
    String? order,
    WazoDirection? direction,
    int? limit,
    int? offset = 0,
    String? search,
    bool recurse = false,
    String? wazoTenant,
  }) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final queryParameters = {
      if (order != null) 'order': order,
      if (direction != null) 'direction': direction.toString(),
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (search != null) 'search': search,
      'recurse': recurse,
    };

    final uri = Uri.parse(
        formatUrl('policies?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
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

  /// Create a new ACL policy set that can be associated to a user, an administrator, a service or a backend.
  /// An ACL policy is a list of ACL or ACL templates that is used to create a token
  /// [name] The name of the policy
  /// [acl] The list of ACL templates to use for the policy
  /// [description] The description of the policy
  /// [shared] Should be shared to sub-tenants or not. Cannot be changed after creation
  /// When [shared] is `true`, then all tenants below this policy's tenant will see it as their own policy with the attribute `read_only: true`.
  /// Using [shared] attribute will add uniqueness constraints for the [slug] among all policies' sub-tenants.
  /// [slug] A unique, human readable identifier for this policy
  Future<Map<String, dynamic>> createPolicy(String name,
      {List<String>? acl,
      String? description,
      bool? shared,
      String? slug,
      String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final body = {
      'name': name,
      ...?acl != null ? {'acl': acl} : null,
      ...?description != null ? {'description': description} : null,
      ...?shared != null ? {'shared': shared} : null,
      ...?slug != null ? {'slug': slug} : null,
    };

    final uri = Uri.parse(formatUrl('policies'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
      body: json.encode(body),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Delete a policy
  /// [policyUuid] The UUID of the policy to delete
  Future<bool> deletePolicy(String policyUuid, {String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('policies/$policyUuid'));

    final response = await httpClient.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the details of a policy
  /// [policyUuid] The UUID of the policy to retrieve
  Future<Map<String, dynamic>> getPolicy(String policyUuid,
      {String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('policies/$policyUuid'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
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

  /// Update a policy
  /// [policyUuid] The UUID of the policy to update
  /// [name] The name of the policy
  /// [acl] The list of ACL templates to use for the policy
  /// [description] The description of the policy
  /// [shared] Should be shared to sub-tenants or not. Cannot be changed after creation
  /// When [shared] is `true`, then all tenants below this policy's tenant will see it as their own policy with the attribute `read_only: true`.
  /// Using [shared] attribute will add uniqueness constraints for the [slug] among all policies' sub-tenants.
  /// [slug] A unique, human readable identifier for this policy
  Future<Map<String, dynamic>> updatePolicy(String policyUuid, String name,
      {List<String>? acl,
      String? description,
      bool? shared,
      String? slug,
      String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final body = {
      'name': name,
      ...?acl != null ? {'acl': acl} : null,
      ...?description != null ? {'description': description} : null,
      ...?shared != null ? {'shared': shared} : null,
      ...?slug != null ? {'slug': slug} : null,
    };

    final uri = Uri.parse(formatUrl('policies/$policyUuid'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
      body: json.encode(body),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Dissociate an access from a policy
  /// [policyUuid] The UUID of the policy to dissociate
  /// [access] The access to add
  Future<bool> dissociateAccessPolicy(String policyUuid, String access,
      {String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('policies/$policyUuid/acl/$access'));

    final response = await httpClient.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Associate an access to a policy
  /// [policyUuid] The UUID of the policy to associate
  /// [access] The access to add
  Future<bool> associateAccessPolicy(String policyUuid, String access,
      {String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('policies/$policyUuid/acl/$access'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the list of accesses associated to a policy
  /// [order] Name of the field to use for sorting the list of items returned.
  /// [direction] Sort list of items in [WazoDirection.asc] (ascending) or [WazoDirection.desc] (descending) order
  /// [limit] Number of items to return
  /// [offset] Index of the first item to return
  /// [search] Search term for filtering a list of items. Only items with a field containing the search term will be returned
  Future<Map<String, dynamic>> getUserPolicies(
    String userUuid, {
    String? order,
    WazoDirection? direction,
    int? limit,
    int? offset = 0,
    String? search,
  }) async =>
      (parent as WazoAuth).users.getUserPolicies(userUuid,
          order: order,
          direction: direction,
          limit: limit,
          offset: offset,
          search: search);

  /// Imported from [WazoAuthUsers.dissociatePolicyFromUser]
  /// Dissociate a policy from a user
  /// [userUuid] The UUID of the user to dissociate
  /// [policyUuid] The UUID of the policy to dissociate
  Future<bool> dissociatePolicyFromUser(
          String policyUuid, String userUuid) async =>
      (parent as WazoAuth).users.dissociatePolicyFromUser(policyUuid, userUuid);

  /// Imported from [WazoAuthUsers.associatePolicyToUser]
  /// Associate a policy to a user
  /// [userUuid] The UUID of the user to associate
  /// [policyUuid] The UUID of the policy to associate
  Future<bool> associatePolicyToUser(
          String policyUuid, String userUuid) async =>
      (parent as WazoAuth).users.associatePolicyToUser(policyUuid, userUuid);
}
