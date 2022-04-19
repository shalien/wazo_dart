import 'dart:convert';

import 'calls/wazo_call_destination.dart';
import 'calls/wazo_call_source.dart';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'calld/wazo_calld_dtmf.dart';

class WazoCalldCalls extends WazoModule {
  WazoCalldCalls(WazoModule parent) : super.fromParent(parent);

  /// Get all active calls for the given [application]
  Future<Map<String, dynamic>> getCalls(
      {String? application, String? applicationInstance}) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final queryParameters = <String, String>{
      if (application != null) 'application': application,
      if (applicationInstance != null)
        'application_instance': applicationInstance,
    };

    final uri = Uri.parse(
        formatUrl('/calls?${encodeQueryParameters(queryParameters)}'));

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

  /// Create a new call from a phone to an extension.
  Future<Map<String, dynamic>> makeCall(WazoCallDestination destination,
      WazoCalldCallSource source, Map<String, dynamic> variables) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls'));

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode({
        'destination': destination.toJson(),
        'source': source.toJson(),
        'variables': variables,
      }),
    );

    switch (response.statusCode) {
      case 201:
        return json.decode(response.body);
      case 400:
      case 503:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Hangup a call
  /// [callId] is the call id
  Future<bool> hangupCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId'));

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

  /// Show a call
  /// [callId] is the call id
  Future<Map<String, dynamic>> getCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId'));

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

  /// Answer a call
  /// [callId] is the call id
  Future<bool> answerCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/answer'));

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

  /// Send a DTMF to a call
  /// [callId] is the call id
  /// [dtmf] is the DTMF to send
  Future<bool> sendDTMF(String callId, List<WazoCalldDtmf> dtmf) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/dtmf'));

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode({'dtmf': dtmf.join()}),
    );

    switch (response.statusCode) {
      case 204:
        return true;
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Put a call on hold
  /// [callId] is the call id
  Future<bool> holdCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/hold/start'));

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

  /// Take a call off hold
  /// [callId] is the call id
  Future<bool> unholdCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/hold/stop'));

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

  /// Mute a call
  /// [callId] is the call id
  Future<bool> muteCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/mute/start'));

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

  /// Unmute a call
  /// [callId] is the call id
  Future<bool> unmuteCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/mute/stop'));

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

  /// Start recording a call
  /// [callId] is the call id
  Future<bool> startRecordingCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/recording/start'));

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

  /// Stop recording a call
  /// [callId] is the call id
  Future<bool> stopRecordingCall(String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/recording/stop'));

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

  /// Connect a call to a user
  /// [callId] is the call id
  /// [userUuid] is the user id
  Future<Map<String, dynamic>> connectCallUser(
      String callId, String userUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/calls/$callId/user/$userUuid'));

    final response = await httpClient.put(
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

  // User related methods

}
