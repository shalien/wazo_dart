import 'wazo_auth_external.dart';

import '../../wazo_client.dart';
import '../wazo_module.dart';
import 'wazo_auth_admin.dart';
import 'wazo_auth_emails.dart';
import 'wazo_auth_groups.dart';
import 'wazo_auth_token.dart';
import 'wazo_auth_users.dart';
import 'wazo_auth_policies.dart';
import 'wazo_auth_sessions.dart';
import 'wazo_auth_tenants.dart';
import 'wazo_auth_backends.dart';
import 'wazo_auth_config.dart';

/// Represents the auth module of the wazo platform.
/// It's separated in modules, each referencing a specific API (admin, backends, groups, etc...).
class WazoAuth extends WazoModule {
  // Create a new WazoAuth module from a [WazoClient]
  WazoAuth(WazoClient client) : super(client, 'auth', '0.1');

  /// Give access to the [WazoAuthAdmin] endpoint methods.
  WazoAuthAdmin get admin => WazoAuthAdmin(this);

  /// Give access to the [WazoAuthUsers] endpoint methods.
  WazoAuthUsers get users => WazoAuthUsers(this);

  /// Give access to the [WazoAuthEmails] endpoint methods.
  WazoAuthEmails get email => WazoAuthEmails(this);

  /// Give access to the [WazoAuthToken] endpoint methods.
  WazoAuthToken get token => WazoAuthToken(this);

  /// Give access to the [WazoAuthBackends] endpoint methods.
  WazoAuthBackends get backends => WazoAuthBackends(this);

  /// Give access to the [WazoAuthConfig] endpoint methods.
  WazoAuthConfig get config => WazoAuthConfig(this);

  /// Give access to the [WazoAuthExternal] endpoint methods.
  WazoAuthExternal get external => WazoAuthExternal(this);

  /// Give access to the [WazoAuthGroups] endpoint methods.
  WazoAuthGroups get groups => WazoAuthGroups(this);

  /// Give access to the [WazoAuthPolicies] endpoint methods.
  WazoAuthPolicies get policies => WazoAuthPolicies(this);

  /// Give access to the [WazoAuthSessions] endpoint methods.
  WazoAuthSessions get sessions => WazoAuthSessions(this);

  /// Give access to the [WazoAuthTenants] endpoint methods.
  WazoAuthTenants get tenants => WazoAuthTenants(this);
}
