import 'dart:convert';

class WazoEmailAddress {
  final String address;
  final bool confirmed;
  final bool main;

  WazoEmailAddress(
    this.address,
    this.confirmed,
    this.main,
  );

  String toJson() {
    return json.encode({
      'address': address,
      'confirmed': confirmed,
      'main': main,
    });
  }
}
