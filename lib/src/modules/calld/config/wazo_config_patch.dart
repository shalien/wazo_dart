import 'dart:convert';

/// A Json Patch operation object
/// Used in [WazoAuthConfig.updateConfig]
class WazoConfigPatch {
  /// The operation to perform
  final String op;

  /// The path to the value to update
  final String path;

  /// The value to update
  final dynamic value;

  /// Create a new [WazoConfigPatch]
  WazoConfigPatch(this.op, this.path, this.value);

  /// Convert the operation to a json string
  String toJson() => json.encode({
        'op': op,
        'path': path,
        'value': value,
      });
}
