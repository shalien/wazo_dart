import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'users/wazo_user_email_address.dart';

/// Represent the `admin` endpoint of the `auth` module
class WazoAuthAdmin extends WazoModule {
  WazoAuthAdmin(WazoModule parent) : super.fromParent(parent);

  /* https://wazo-platform.org/documentation/api/authentication.html#tag/users/paths/~1admin~1users~1{user_uuid}~1emails/put */
  /// Update all of the users ([userUuid]) email address ([WazoUserEmailAddress]) at the same time.
  /// If an existing address is missing from the list, it will be removed.
  /// An empty list will remove all addresses.
  /// If [addresses] are defined, one and only one address should be [WazoUserEmailAddress.main].
  /// If the [WazoUserEmailAddress.confirmed] field is set to none or omitted the existing value will be reused if it exists, otherwise the address will not be confirmed.
  Future<Map<String, dynamic>> updateAdminEmailAddress(
      String userUuid, List<WazoUserEmailAddress> addresses) async {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('/admin/users/$userUuid/emails'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode(
        addresses.map((address) => address.toJson()).toList(),
      ),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
