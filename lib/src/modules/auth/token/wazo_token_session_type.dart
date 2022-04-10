/// Represent the type of session the token will be used with
enum WazoTokenSessionType {
  /// Desktop usage
  desktop,

  /// Mobile usage
  mobile;

  /// Returns the string representation of the enum
  @override
  String toString() {
    switch (this) {
      case WazoTokenSessionType.desktop:
        return 'desktop';
      case WazoTokenSessionType.mobile:
        return 'mobile';
    }
  }
}
