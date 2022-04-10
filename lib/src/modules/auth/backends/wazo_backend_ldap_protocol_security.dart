/// Represent the security protocol available for the LDAP backend
enum WazoBackendLdapProtocolSecurity {
  /// No security
  none,

  /// TLS
  tls,

  /// Secure LDAP
  ldaps;

  /// Returns the string representation of the enum
  @override
  String toString() {
    switch (this) {
      case WazoBackendLdapProtocolSecurity.none:
        return '';
      case WazoBackendLdapProtocolSecurity.tls:
        return 'tls';
      case WazoBackendLdapProtocolSecurity.ldaps:
        return 'ldaps';
    }
  }
}
