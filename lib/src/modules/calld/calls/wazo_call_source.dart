import 'dart:convert';

/// Represent a source for a call
class WazoCalldCallSource {
  /// Use all of the lines of the [user] to make the call (ignored when [lineId] is specified).
  bool? allLines;

  /// Inform the phone that it should answer automatically.
  /// Limitation: this does not work if [allLines] is true, if [fromMobile] is true or if the phone is SCCP.
  bool? autoAnswer;

  /// Start the call from the [user]'s mobile phone. Default is False
  bool? fromMobile;

  /// ID of the line of the [user] used to make the call.
  /// Default is the main line of the [user].
  int? lineId;

  /// UUID of the [user] making the call
  final String user;

  /// Create a new [WazoCalldCallSource] for making call using [WazoCalldCalls.makeCall]
  WazoCalldCallSource(
    this.user, {
    this.allLines,
    this.autoAnswer,
    this.fromMobile = false,
    this.lineId,
  });

  /// Convert a [WazoCalldCallSource] to a json string
  String toJson() {
    final jsonString = <String, dynamic>{
      'user': user,
    };

    if (allLines != null) {
      jsonString['all_lines'] = allLines;
    }

    if (autoAnswer != null) {
      jsonString['auto_answer'] = autoAnswer;
    }

    if (fromMobile != null) {
      jsonString['from_mobile'] = fromMobile;
    }

    if (lineId != null) {
      jsonString['line_id'] = lineId;
    }

    return json.encode(jsonString);
  }
}
