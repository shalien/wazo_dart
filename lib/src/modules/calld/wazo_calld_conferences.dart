import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';

class WazoCalldConferences extends WazoModule {
  WazoCalldConferences(WazoModule parent) : super.fromParent(parent);

  /// List participants of a conference
  /// [conferenceId] is the conference uuid
  Future<Map<String, dynamic>> getConferenceParticipants(
      String conferenceId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/conferences/$conferenceId/participants'));

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

  /// Kick participant from a conference
  /// [conferenceId] is the conference uuid
  /// [participantId] is the participant uuid
  Future<bool> kickParticipant(
      String conferenceId, String participantId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(
        formatUrl('/conferences/$conferenceId/participants/$participantId'));

    final response = await httpClient.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Mute a participant in a conference
  /// [conferenceId] is the conference uuid
  /// [participantId] is the participant uuid
  Future<bool> muteParticipant(
      String conferenceId, String participantId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl(
        '/conferences/$conferenceId/participants/$participantId/mute'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Unmute a participant in a conference
  /// [conferenceId] is the conference uuid
  /// [participantId] is the participant uuid
  Future<bool> unmuteParticipant(
      String conferenceId, String participantId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl(
        '/conferences/$conferenceId/participants/$participantId/unmute'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Stop recording a conference
  /// [conferenceId] is the conference uuid
  Future<bool> stopRecordingConference(String conferenceId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/conferences/$conferenceId/record'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Start recording a conference
  /// [conferenceId] is the conference uuid
  Future<bool> startRecordingConference(String conferenceId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/conferences/$conferenceId/record'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
    );

    switch (response.statusCode) {
      case 204:
        return true;
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  // user related methods
}
