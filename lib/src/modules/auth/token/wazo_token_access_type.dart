/// Represent the type of token that can be requested to wazo-authd
enum WazoTokenAccessType {
  /// The token is used to authenticate the user
  online,

  /// The token is used to authenticate the user and to access the offline API
  offline;

  /// Returns the string representation of the enum
  @override
  String toString() {
    switch (this) {
      case WazoTokenAccessType.online:
        return 'online';
      case WazoTokenAccessType.offline:
        return 'offline';
    }
  }
}
