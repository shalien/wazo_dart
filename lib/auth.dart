/// This library is a wrapper around the authd API.
/// It's separated in modules, each referencing a specific API Endpoint and its methods (admin, backends, groups, etc...).
/// Implemented following the [Wazo REST API](https://wazo-platform.org/documentation/api/authentication.html)
library auth;

// Backend
export 'src/modules/auth/wazo_auth_backends.dart';
export 'src/modules/auth/backends/wazo_backend_ldap_protocol_security.dart';
export 'src/modules/auth/backends/wazo_backend_ldap_search_filters.dart';
export 'src/modules/auth/backends/wazo_backend_ldap_version.dart';

// Config
export 'src/modules/auth/wazo_auth_config.dart';
export 'src/modules/auth/config/wazo_config_patch.dart';

// Tenants
export 'src/modules/auth/wazo_auth_tenants.dart';
export 'src/modules/auth/tenants/wazo_tenant_address.dart';

// Token
export 'src/modules/auth/wazo_auth_token.dart';
export 'src/modules/auth/token/wazo_token_access_type.dart';
export 'src/modules/auth/token/wazo_token_session_type.dart';

// Admin
export 'src/modules/auth/wazo_auth_admin.dart';

// Emails
export 'src/modules/auth/wazo_auth_emails.dart';

// External
export 'src/modules/auth/wazo_auth_external.dart';

// Groups
export 'src/modules/auth/wazo_auth_groups.dart';

// Policies
export 'src/modules/auth/wazo_auth_policies.dart';

// Sessions
export 'src/modules/auth/wazo_auth_sessions.dart';

// Users
export 'src/modules/auth/wazo_auth_users.dart';

// WazoAuth
export 'src/modules/auth/wazo_auth.dart';
