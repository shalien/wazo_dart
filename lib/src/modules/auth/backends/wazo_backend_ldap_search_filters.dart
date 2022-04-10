/// Represent the search filters accepted by the Wazo API for the LDAP binding
enum WazoBackendLdapSearchFilters {
  /// Search for the user by its username
  username,

  /// Search for the user by its login
  userLoginAttribute,

  /// Search for the user by its email
  userEmailAttribute;

  /// Returns the string representation of the enum
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
