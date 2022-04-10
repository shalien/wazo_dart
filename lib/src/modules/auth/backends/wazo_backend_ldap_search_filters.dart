enum WazoBackendLdapSearchFilters {
  username,
  userLoginAttribute,
  userEmailAttribute;

  @override
  String toString() {
    switch (this) {
      case WazoBackendLdapSearchFilters.username:
        return 'username';
      case WazoBackendLdapSearchFilters.userLoginAttribute:
        return 'user_login_attribute';
      case WazoBackendLdapSearchFilters.userEmailAttribute:
        return 'user_email_attribute';
    }
  }
}
