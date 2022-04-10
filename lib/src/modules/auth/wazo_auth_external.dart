import 'dart:convert';

import '../../wazo_direction.dart';
import '../../wazo_exception.dart';
import '../wazo_module.dart';

class WazoAuthExternal extends WazoModule {
  WazoAuthExternal(WazoModule parent) : super.fromParent(parent);

  /// Delete the client id and client secret
  /// [authType] External auth type name
  Future<bool> deleteClientIdSecret(String authType,
      {String? wazoTenant}) async {
    final uri = Uri.parse(formatUrl('external/$authType/config'));

    final response = await httpClient.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
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

  /// Retrieve the client id and client secret
  /// [authType] External auth type name
  Future<Map<String, dynamic>> getClientIdSecret(String authType,
      {String? wazoTenant}) async {
    final uri = Uri.parse(formatUrl('external/$authType/config'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
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

  /// Add configuration for the given [authType]
  /// [authType] External auth type name
  /// [clientId] Client ID for the given authentication type. Required only for `google` and `microsoft` authentication types.
  /// [clientSecret] Client secret for the given authentication type. Required only for `google` and `microsoft` authentication types.
  /// [fcmApiKey] The API key to use for Firebase Cloud Messaging
  /// [iosApnCertificate] Public certificate to use for Apple Push Notification Service
  /// [iosApnPrivate] Private key to use for Apple Push Notification Service
  /// [useSandbox] Whether to use sandbox for Apple Push Notification Service
  Future<bool> createClientIdSecret(String authType,
      {String? clientId,
      String? clientSecret,
      String? fcmApiKey,
      String? iosApnCertificate,
      String? iosApnPrivate,
      bool? useSandbox,
      String? wazoTenant}) async {
    final uri = Uri.parse(formatUrl('external/$authType/config'));

    final queryParameters = {
      ...?clientId != null ? {'client_id': clientId} : null,
      ...?clientSecret != null ? {'client_secret': clientSecret} : null,
      ...?fcmApiKey != null ? {'fcm_api_key': fcmApiKey} : null,
      ...?iosApnCertificate != null
          ? {'ios_apn_certificate': iosApnCertificate}
          : null,
      ...?iosApnPrivate != null ? {'ios_apn_private': iosApnPrivate} : null,
      ...?useSandbox != null ? {'use_sandbox': useSandbox} : null,
    };

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
      body: json.encode({
        ...queryParameters,
      }),
    );

    switch (response.statusCode) {
      case 201:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Update configuration for the given [authType]
  /// [authType] External auth type name
  /// [clientId] Client ID for the given authentication type. Required only for `google` and `microsoft` authentication types.
  /// [clientSecret] Client secret for the given authentication type. Required only for `google` and `microsoft` authentication types.
  /// [fcmApiKey] The API key to use for Firebase Cloud Messaging
  /// [iosApnCertificate] Public certificate to use for Apple Push Notification Service
  /// [iosApnPrivate] Private key to use for Apple Push Notification Service
  /// [useSandbox] Whether to use sandbox for Apple Push Notification Service
  Future<bool> updateClientIdSecret(String authType,
      {String? clientId,
      String? clientSecret,
      String? fcmApiKey,
      String? iosApnCertificate,
      String? iosApnPrivate,
      bool? useSandbox,
      String? wazoTenant}) async {
    final uri = Uri.parse(formatUrl('external/$authType/config'));

    final queryParameters = {
      ...?clientId != null ? {'client_id': clientId} : null,
      ...?clientSecret != null ? {'client_secret': clientSecret} : null,
      ...?fcmApiKey != null ? {'fcm_api_key': fcmApiKey} : null,
      ...?iosApnCertificate != null
          ? {'ios_apn_certificate': iosApnCertificate}
          : null,
      ...?iosApnPrivate != null ? {'ios_apn_private': iosApnPrivate} : null,
      ...?useSandbox != null ? {'use_sandbox': useSandbox} : null,
    };

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        ...?wazoTenant != null ? {'Wazo-Tenant': wazoTenant} : null,
      },
      body: json.encode({
        ...queryParameters,
      }),
    );

    switch (response.statusCode) {
      case 200:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Retrieves the list of the users external auth data
  /// [userUuid] The UUID of the user
  /// [order] Name of the field to use for sorting the list of items returned.
  /// [direction] Sort list of items in [WazoDirection.asc] (ascending) or [WazoDirection.desc] (descending) order
  /// [limit] Number of items to return
  /// [offset] Index of the first item to return
  /// [search] Search term for filtering a list of items. Only items with a field containing the search term will be returned
  Future<Map<String, dynamic>> getUserExternalAuthData(String userUuid,
      {String? order,
      WazoDirection? direction,
      int? limit,
      int? offset = 0,
      String? search}) async {
    if (apiToken == null) {
      throw ArgumentError('apiToken is required');
    }
    final queryParameters = {
      ...?order != null ? {'order': order} : null,
      ...?direction != null ? {'direction': direction} : null,
      ...?limit != null ? {'limit': limit} : null,
      ...?offset != null ? {'offset': offset} : null,
      ...?search != null ? {'search': search} : null,
    };

    final uri = Uri.parse(formatUrl(
        'users/$userUuid/external?${encodeQueryParameters(queryParameters)}'));

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
}
