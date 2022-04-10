import 'dart:convert';

/// Represent a TenantAddress
class WazoTenantAddress {
  /// The tenant's city
  final String city;

  /// The tenant's country
  final String country;

  /// The tenant's address
  final String line1;

  /// The tenant's address
  final String line2;

  /// The tenant's state
  final String state;

  /// The tenant's zip code
  final String zipCode;

  /// Create a new [WazoTenantAddress]
  WazoTenantAddress(
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.state,
    this.zipCode,
  );

  /// Encodes the [WazoTenantAddress] to a json string
  String toJson() {
    return json.encode({
      'city': city,
      'country': country,
      'line_1': line1,
      'line_2': line2,
      'state': state,
      'zip_code': zipCode,
    });
  }
}
