import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';

class WazoCalldMeetings extends WazoModule {
  WazoCalldMeetings(WazoModule parent) : super.fromParent(parent);

  /// Get the status of a meeting
  /// [meetingUuid] is the meeting uuid
  Future<Map<String, dynamic>> getMeetingStatus(String meetingUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/guests/me/meetings/$meetingUuid/status'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// List participants of a meeting
  /// [meetingUuid] is the meeting uuid
  Future<Map<String, dynamic>> getMeetingParticipants(
      String meetingUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/meetings/$meetingUuid/participants'));

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
