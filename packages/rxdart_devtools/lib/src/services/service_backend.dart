import 'dart:convert';
import 'dart:developer' as developer;

import 'package:rxdart_devtools/src/services/streams.dart';
import '../dto/snapshot.dart';
import '../devtools/constants.dart';

abstract final class ServiceBackend {
  static void register() {
    developer.registerExtension(Constants.list, _handleList);
    developer.registerExtension(Constants.clearClosed, _handleClearClosed);
  }

  static Future<developer.ServiceExtensionResponse> _handleList(
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

  static Future<developer.ServiceExtensionResponse> _handleClearClosed(
    String method,
    Map<String, String> parameters,
  ) async {
    Streams.instance.clearClosed();
    return developer.ServiceExtensionResponse.result(jsonEncode({'ok': true}));
  }
}
