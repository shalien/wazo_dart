/// Represent the order in which the results should be returned
enum WazoDirection {
  /// Ascending order
  asc,

  /// Descending order
  desc;

  /// Returns the string representation of the enum
  @override
  String toString() {
    switch (this) {
      case WazoDirection.asc:
        return 'asc';
      case WazoDirection.desc:
        return 'desc';
    }
  }
}
