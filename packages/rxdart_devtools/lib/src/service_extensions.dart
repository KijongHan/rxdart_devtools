import 'dart:convert';
import 'dart:developer' as developer;

import 'registry.dart';
import 'wire/snapshot.dart';

abstract final class ServiceExtensions {
  static const String list = 'ext.rxdart.list';
  static const String clearClosed = 'ext.rxdart.clearClosed';

  static void register() {
    developer.registerExtension(list, _handleList);
    developer.registerExtension(clearClosed, _handleClearClosed);
  }

  static Future<developer.ServiceExtensionResponse> _handleList(
    String method,
    Map<String, String> parameters,
  ) async {
    final entries = Registry.instance.all
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
    Registry.instance.clearClosed();
    return developer.ServiceExtensionResponse.result(jsonEncode({'ok': true}));
  }
}
