/// Represent the purpose of the user created
enum WazoUserPurpose {
  /// The user is a regular user
  user,

  /// The user is a tenant administrator
  internal,

  /// The user is api client
  externalApi;

  /// Returns the string representation of the enum
  @override
  String toString() {
    switch (this) {
      case WazoUserPurpose.user:
        return 'user';
      case WazoUserPurpose.internal:
        return 'internal';
      case WazoUserPurpose.externalApi:
        return 'external_api';
    }
  }
}
