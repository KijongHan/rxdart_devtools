import 'dart:convert';
import 'dart:developer' as developer;

import 'package:rxdart_devtools/src/providers/get_it.dart';
import 'package:rxdart_devtools/src/services/events.dart';
import 'package:rxdart_devtools/src/services/streams.dart';
import '../dto/stream_entry.dart';
import '../devtools/constants.dart';

final class ServiceBackend {
  final streamsService = getIt.get<StreamsService>();
  final eventsService = getIt.get<EventsService>();

  ServiceBackend() {
    developer.registerExtension(
        Constants.listStreamEntries, _handleListStreamEntries);
    developer.registerExtension(Constants.clearClosed, _handleClearClosed);
  }

  Future<developer.ServiceExtensionResponse> _handleListStreamEntries(
    String method,
    Map<String, String> parameters,
  ) async {
    final entries = streamsService.all
        .map((entry) => StreamEntryDto.fromEntry(entry).toJson())
        .toList();
    return developer.ServiceExtensionResponse.result(
      jsonEncode({'entries': entries}),
    );
  }

  Future<developer.ServiceExtensionResponse> _handleListEventLogs(
    String method,
    Map<String, String> parameters,
  ) async {
    final eventLogs = eventsService.all.toList();
    return developer.ServiceExtensionResponse.result(
      jsonEncode({'eventLogs': eventLogs}),
    );
  }

  Future<developer.ServiceExtensionResponse> _handleClearClosed(
    String method,
    Map<String, String> parameters,
  ) async {
    streamsService.clearClosed();
    return developer.ServiceExtensionResponse.result(jsonEncode({'ok': true}));
  }
}
