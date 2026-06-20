import 'dart:convert';
import 'dart:developer' as developer;

import 'package:rxdart_devtools/src/services/events.dart';
import 'package:rxdart_devtools/src/services/streams.dart';
import '../dto/snapshot.dart';
import '../devtools/constants.dart';

abstract final class ServiceBackend {
  static void register() {
    developer.registerExtension(
        Constants.listStreamEntries, _handleListStreamEntries);
    developer.registerExtension(Constants.clearClosed, _handleClearClosed);
  }

  static Future<developer.ServiceExtensionResponse> _handleListStreamEntries(
    String method,
    Map<String, String> parameters,
  ) async {
    final entries = Streams.instance.all
        .map((entry) => TrackedSnapshot.fromEntry(entry).toJson())
        .toList();
    return developer.ServiceExtensionResponse.result(
      jsonEncode({'entries': entries}),
    );
  }

  static Future<developer.ServiceExtensionResponse> _handleListEventLogs(
    String method,
    Map<String, String> parameters,
  ) async {
    final eventLogs = Events.instance.all.toList();
    return developer.ServiceExtensionResponse.result(
      jsonEncode({'eventLogs': eventLogs}),
    );
  }

  static Future<developer.ServiceExtensionResponse> _handleClearClosed(
    String method,
    Map<String, String> parameters,
  ) async {
    Streams.instance.clearClosed();
    return developer.ServiceExtensionResponse.result(jsonEncode({'ok': true}));
  }
}
