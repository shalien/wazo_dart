import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'wazo_email_address.dart';

class WazoAuthAdmin extends WazoModule {
  WazoAuthAdmin(WazoModule parent) : super.fromParent(parent);

  /* https://wazo-platform.org/documentation/api/authentication.html#tag/users/paths/~1admin~1users~1{user_uuid}~1emails/put */
  /// Update all of the users ([userUuid]) email address ([WazoEmailAddress]) at the same time.
  /// If an existing address is missing from the list, it will be removed.
  /// An empty [list] will remove all addresses.
  /// If [addresses] are defined, one and only one address should be [WazoEmailAddress.main].
  /// If the [WazoEmailAddress.confirmed] field is set to none or omitted the existing value will be reused if it exists, otherwise the address will not be confirmed.
  Future<List<String>> updateAdminEmailAddress(
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
}
