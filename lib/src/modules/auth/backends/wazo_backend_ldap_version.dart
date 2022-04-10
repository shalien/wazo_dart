/// Represents the version of the LDAP protocol accepted by wazo-authd.
enum WazoBackendLdapVersion {
  /// Version 2
  v2,

  /// Version 3
  v3;

  /// Returns the string representation of the enum
  @override
  String toString() {
    switch (this) {
      case WazoBackendLdapVersion.v2:
        return '2';
      case WazoBackendLdapVersion.v3:
        return '3';
    }
  }
}
