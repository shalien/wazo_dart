import 'package:wazo_dart/auth.dart';

import '../../wazo_exception.dart';
import '../wazo_module.dart';

/// Represents the `emails` endpoint of the `auth` module.
class WazoAuthEmails extends WazoModule {
  WazoAuthEmails(WazoModule parent) : super.fromParent(parent);

  /// Confirm an email address using a GET request
  /// The [token] should be in the URL instead of being in the HTTP headers
  /// [emailUuid] is the email address uuid
  /// [token] is the UUID of the token used to confirm the email address
  Future<bool> confirmEmailAddressWithToken(
      String emailUuid, String token) async {
    final uri = Uri.parse(formatUrl('email/$emailUuid/confirm?token=$token'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Confirm an email address using a PUT request
  /// [emailUuid] is the email address uuid
  Future<bool> confirmEmailAddress(String emailUuid) {
    if (apiToken == null) {
      throw UnsupportedError('No token available');
    }

    final uri = Uri.parse(formatUrl('email/$emailUuid/confirm'));

    return httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    ).then((response) {
      switch (response.statusCode) {
        case 204:
          return true;
        default:
          throw WazoException.fromResponse(response);
      }
    });
  }

  Future<Map<String, dynamic>> updateUserEmailAddress(userUuid, emails) async =>
      (parent as WazoAuth).users.updateUserEmailAddress(userUuid, emails);

  Future<bool> askNewConfirmationEmail(userUuid, emailUuid) async =>
      (parent as WazoAuth).users.askNewConfirmationEmail(userUuid, emailUuid);
}
