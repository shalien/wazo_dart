enum WazoBackendLdapVersion {
  v2,
  v3;

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
