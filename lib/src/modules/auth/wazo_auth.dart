import 'wazo_auth_external.dart';

import 'wazo_admin_token.dart';
import 'wazo_auth_backends.dart';
import 'wazo_auth_config.dart';

import '../../wazo_client.dart';
import '../wazo_module.dart';
import 'wazo_auth_admin.dart';
import 'wazo_auth_emails.dart';
import 'wazo_auth_groups.dart';
import 'wazo_auth_users.dart';

class WazoAuth extends WazoModule {
  WazoAuth(WazoClient client) : super(client, 'auth', '0.1');

  /// Give access to the [WazoAuthAdmin] methods.
  WazoAuthAdmin get admin => WazoAuthAdmin(this);

  /// Give access to the [WazoAuthUsers] methods.
  WazoAuthUsers get users => WazoAuthUsers(this);

  /// Give access to the [WazoAuthEmails] methods.
  WazoAuthEmails get email => WazoAuthEmails(this);

  /// Give access to the [WazoAuthToken] methods.
  WazoAuthToken get token => WazoAuthToken(this);

  /// Give access to the [WazoAuthBackends] methods.
  WazoAuthBackends get backends => WazoAuthBackends(this);

  /// Give access to the [WazoAuthConfig] methods.
  WazoAuthConfig get config => WazoAuthConfig(this);

  /// Give access to the [WazoAuthExternal] methods.
  WazoAuthExternal get external => WazoAuthExternal(this);

  /// Give access to the [WazoAuthGroups] methods.
  WazoAuthGroups get groups => WazoAuthGroups(this);
}
