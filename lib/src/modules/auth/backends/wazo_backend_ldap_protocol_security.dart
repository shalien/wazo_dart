enum WazoBackendLdapProtocolSecurity {
  none,
  tls,
  ldaps;

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
