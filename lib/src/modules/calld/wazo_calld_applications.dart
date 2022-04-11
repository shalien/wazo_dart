import 'dart:convert';

import '../../wazo_exception.dart';
import '../wazo_module.dart';
import 'applications/wazo_calld_application_dtmf.dart';

/// Represent the `applications` endpoint of the `calld` module
class WazoCalldApplications extends WazoModule {
  WazoCalldApplications(WazoModule? parent) : super.fromParent(parent);

  /// Show an application
  /// [applicationUuid] is the application uuid
  Future<Map<String, dynamic>> getApplication(String applicationUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/applications/$applicationUuid'));

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

  /// List calls from the application
  /// [applicationUuid] is the application uuid
  Future<Map<String, dynamic>> getApplicationCalls(
      String applicationUuid) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/applications/$applicationUuid/calls'));

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

  /// Make a new call to the application
  /// [applicationUuid] is the application uuid
  /// Channel [variables] that should be assigned on this new channel
  Future<Map<String, dynamic>> makeApplicationCall(
      String applicationUuid, String context, String exten,
      {bool? autoanswer = false,
      String? displayedCallerIdName,
      String? displayedCallerIdNumber,
      Map<String, dynamic>? variables}) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(formatUrl('/applications/$applicationUuid/calls'));

    final body = {
      'context': context,
      'exten': exten,
      ...?autoanswer != null ? {'autoanswer': autoanswer} : null,
      ...?displayedCallerIdName != null
          ? {'displayed_caller_id_name': displayedCallerIdName}
          : null,
      ...?displayedCallerIdNumber != null
          ? {'displayed_caller_id_number': displayedCallerIdNumber}
          : null,
      ...?variables != null ? {'variables': variables} : null,
    };

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode(body),
    );

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Hangup a call from the application
  /// [applicationUuid] is the application uuid
  /// [callId] is the call id
  Future<bool> hangupApplicationCall(
      String applicationUuid, String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri =
        Uri.parse(formatUrl('/applications/$applicationUuid/calls/$callId'));

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

  /// Answer a call
  /// [applicationUuid] is the application uuid
  /// [callId] is the call id
  Future<bool> answerApplicationCall(
      String applicationUuid, String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri =
        Uri.parse(formatUrl('/applications/$applicationUuid/calls/$callId'));

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

  /// Simulate a user pressing DTMF keys
  /// [applicationUuid] is the application uuid
  /// [callId] is the call id
  /// [digits] to send via DTMF. Must contain only 0-9*#.
  Future<bool> simulateApplicationCallDtmf(String applicationUuid,
      String callId, List<WazoCalldApplicationDtmf> digits) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(
        formatUrl('/applications/$applicationUuid/calls/$callId/dtmf'));

    final body = {
      'digits': digits.map((d) => d.toString()).toList(),
    };

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '$apiToken',
      },
      body: json.encode(body),
    );

    switch (response.statusCode) {
      case 204:
        return true;
      case 404:
      default:
        throw WazoException.fromResponse(response);
    }
  }

  /// Place a call on hold
  /// [applicationUuid] is the application uuid
  /// [callId] is the call id
  Future<bool> placeApplicationCallOnHold(
      String applicationUuid, String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(
        formatUrl('/applications/$applicationUuid/calls/$callId/hold/start'));

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

  /// Resume a call that has been placed on hold
  /// [applicationUuid] is the application uuid
  /// [callId] is the call id
  Future<bool> resumeApplicationCallOnHold(
      String applicationUuid, String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(
        formatUrl('/applications/$applicationUuid/calls/$callId/hold/stop'));

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

  /// Stops playing a music on hold
  /// [applicationUuid] is the application uuid
  /// [callId] is the call id
  Future<bool> stopApplicationCallMusicOnHold(
      String applicationUuid, String callId) async {
    if (apiToken == null) {
      throw ArgumentError('No token available');
    }

    final uri = Uri.parse(
        formatUrl('/applications/$applicationUuid/calls/$callId/moh/stop'));

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
}
