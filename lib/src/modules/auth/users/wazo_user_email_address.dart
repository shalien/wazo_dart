import 'dart:convert';

/// A Email Address implementation for the [WazoAuth.users] endpoint
class WazoUserEmailAddress {
  /// The email address
  final String address;

  /// Is the email confirmed
  final bool confirmed;

  /// Is the main email of the user
  final bool main;

  /// Create a new [WazoUserEmailAddress]
  WazoUserEmailAddress(
    this.address,
    this.confirmed,
    this.main,
  );

  /// Convert the [WazoUserEmailAddress] to a json string
  /// Used for requests
  String toJson() {
    return json.encode({
      'address': address,
      'confirmed': confirmed,
      'main': main,
    });
  }
}
