import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'backends/wazo_backend_ldap_protocol_security.dart';
import 'backends/wazo_backend_ldap_search_filters.dart';
import 'backends/wazo_backend_ldap_version.dart';

class WazoAuthBackends extends WazoModule {
  WazoAuthBackends(WazoModule parent) : super.fromParent(parent);

  /// Retrieves the list of activated backends
  Future<Map<String, dynamic>> getBackends() async {
    final uri = Uri.parse(formatUrl('backends'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Delete current [wazoTenant]'s LDAP backend configuration
  Future<bool> deleteBackendLdap(String wazoTenant) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('backends/ldap'));

    final response = await httpClient.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        'Wazo-Tenant': wazoTenant,
      },
    );
    switch (response.statusCode) {
      case 204:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Get current tenant's LDAP backend configuration.
  /// If there is no configuration, all the fields will be `null`.
  Future<Map<String, dynamic>> getBackendLdap(String wazoTenant) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('backends/ldap'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        'Wazo-Tenant': wazoTenant,
      },
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Update current tenant's LDAP backend configuration
  /// [wazoTenant] is the tenant's UUID, defining the ownership of a given resource
  /// [bindDn] is the DN to use to bind the wazo-auth service to the LDAP server.
  /// If unspecified, wazo-auth will not bind with a service user but only with the final user account.
  /// For this to work though, your users will need to have the right to read their own information, particularly their email address.
  /// [host] The host or IP address of the LDAP server.
  /// [port] The port of the LDAP server.
  /// [protocolSecurity] The protocol security to use to connect to the LDAP server.
  /// [protocolVersion] The protocol version to use to connect to the LDAP server.
  /// [searchFilters] Filters for finding a user DN given a service bind is used. Available variables are [WazoBackendLdapSearchFilters.username], [WazoBackendLdapSearchFilters.userLoginAttribute] and [WazoBackendLdapSearchFilters.userEmailAttribute].
  /// These variables come from the fields of the same name from the API.
  /// [userBaseDn] The base DN to use to search for users.
  /// [userEmailAttribute] The attribute to use to find the user's email address.
  /// [userLoginAttribute] The attribute to use to find the user's login.
  /// [bindPassword] The password to use to bind to the LDAP server.
  Future<Map<String, dynamic>> updateBackendLdap(
      String wazoTenant,
      String host,
      int port,
      String userBaseDn,
      String userEmailAttribute,
      String userLoginAttribute,
      {String? bindDn,
      WazoBackendLdapProtocolSecurity? protocolSecurity =
          WazoBackendLdapProtocolSecurity.none,
      WazoBackendLdapVersion protocolVersion = WazoBackendLdapVersion.v3,
      WazoBackendLdapSearchFilters? searchFilters,
      String? bindPassword}) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final queryParameters = <String, dynamic>{
      ...?bindDn != null ? {'bind_dn': bindDn} : null,
      'host': host,
      'port': port,
      'protocol_security': protocolSecurity.toString(),
      'protocol_version': protocolVersion.toString(),
      ...?searchFilters != null ? {'search_filters': searchFilters} : null,
      'user_base_dn': userBaseDn,
      'user_email_attribute': userEmailAttribute,
      'user_login_attribute': userLoginAttribute,
      ...?bindPassword != null ? {'bind_password': bindPassword} : null,
    };

    final uri = Uri.parse(formatUrl('backends/ldap'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
        'Wazo-Tenant': wazoTenant,
      },
      body: json.encode(queryParameters),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
