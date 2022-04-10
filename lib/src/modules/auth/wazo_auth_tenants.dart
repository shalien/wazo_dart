import 'dart:convert';

import '../../wazo_direction.dart';
import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'tenants/wazo_tenant_address.dart';

/// Represents the `tenants` endpoint of the `auth` module.
class WazoAuthTenants extends WazoModule {
  WazoAuthTenants(WazoModule parent) : super.fromParent(parent);

  /// Get the list of tenants
  /// [order] Name of the field to use for sorting the list of items returned.
  /// [direction] Sort list of items in [WazoDirection.asc] (ascending) or [WazoDirection.desc] (descending) order
  /// [limit] Number of items to return
  /// [offset] Index of the first item to return
  /// [search] Search term for filtering a list of items. Only items with a field containing the search term will be returned
  Future<Map<String, dynamic>> getTenants(
      {String? order,
      WazoDirection? direction,
      int? limit,
      int? offset = 0,
      String? search,
      String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final queryParameters = {
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction} : null,
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
      ...?search != null ? {'search': search} : null,
    };

    final uri = Uri.parse(
        formatUrl('tenants?${encodeQueryParameters(queryParameters)}'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?wazoTenant != null ? {'X-Wazo-Tenant': wazoTenant} : null,
      },
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Creates a new tenant
  /// [address] The [WazoTenantAddress] of the new tenant
  /// [contact] The contact of the new tenant
  /// [name] The name of the new tenant
  /// [phone] The phone number of the new tenant
  /// [slug] The slug of the new tenant
  /// [uuid] The UUID of the new tenant
  Future<Map<String, dynamic>> createTenant(WazoTenantAddress address,
      String contact, String name, String phone, String slug, String uuid,
      {String? wazoTenant}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('tenants'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
      body: json.encode({
        'address': address.toJson(),
        'contact': contact,
        'name': name,
        'phone': phone,
        'slug': slug,
        'uuid': uuid,
      }),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Delete the tenant with the given [tenantUuid]
  /// [tenantUuid] The UUID of the tenant to delete
  Future<bool> deleteTenant(String tenantUuid) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('tenants/$tenantUuid'));

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

  /// Retrieves the details of a tenant
  /// [tenantUuid] The UUID of the tenant to retrieve
  Future<Map<String, dynamic>> getTenant(String tenantUuid) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('tenants/$tenantUuid'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Update the tenant with the given [tenantUuid]
  /// [address] The [WazoTenantAddress] of the tenant
  /// [contact] The contact of the tenant
  /// [name] The name of the tenant
  /// [phone] The phone number of the tenant
  Future<Map<String, dynamic>> updateTenant(String tenantUuid,
      {WazoTenantAddress? address,
      String? contact,
      String? name,
      String? phone}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final body = {
      ...?address != null ? {'address': address.toJson()} : null,
      ...?contact != null ? {'contact': contact} : null,
      ...?name != null ? {'name': name} : null,
      ...?phone != null ? {'phone': phone} : null,
    };

    final uri = Uri.parse(formatUrl('tenants/$tenantUuid'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
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
}
