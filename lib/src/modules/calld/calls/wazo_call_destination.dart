import 'dart:convert';

/// The destination of a call
class WazoCallDestination {
  /// The [context] used for the destination
  final String context;

  /// The [extension] used for the destination
  final String extension;

  /// The [priority] used for the call
  final int priority;

  /// Create a new [WazoCallDestination] for making call using [WazoCalldCalls.makeCall]
  WazoCallDestination(this.context, this.extension, this.priority);

  /// Convert a [WazoCallDestination] to a json string
  String toJson() {
    final jsonString = <String, dynamic>{
      'context': context,
      'extension': extension,
      'priority': priority,
    };

    return json.encode(jsonString);
  }
}
