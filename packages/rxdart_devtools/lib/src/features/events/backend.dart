import 'dart:convert';
import 'dart:developer' as developer;
import 'package:rxdart_devtools/src/features/events/constants.dart';
import 'package:rxdart_devtools/src/features/events/dto.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/providers/get_it.dart';

final class EventsBackend {
  final eventsService = getIt.get<EventsService>();
  final registryService = getIt.get<RegistryService>();

  EventsBackend() {
    developer.registerExtension(
        EventsConstants.listEventLogs, _handleListEventLogs);
    developer.registerExtension(
        EventsConstants.listStreamEventLogs, _handleListStreamEventLogs);
  }

  Future<developer.ServiceExtensionResponse> _handleListEventLogs(
    String method,
    Map<String, String> parameters,
  ) async {
    final eventLogs = eventsService.all
        .map((log) => EventLogDto.fromEventLog(log).toJson())
        .toList();
    return developer.ServiceExtensionResponse.result(
      jsonEncode({EventsConstants.jsonEventLogs: eventLogs}),
    );
  }

  Future<developer.ServiceExtensionResponse> _handleListStreamEventLogs(
    String method,
    Map<String, String> parameters,
  ) async {
    final streamId = parameters[EventsConstants.jsonStreamId];
    if (streamId == null) {
      return developer.ServiceExtensionResponse.error(
        400,
        'Stream ID is required',
      );
    }

    final streamIdentifier = registryService.getStreamIdentifier(streamId);
    if (streamIdentifier == null) {
      return developer.ServiceExtensionResponse.error(
        404,
        'Stream not found',
      );
    }

    final eventLogs = eventsService
        .allForStream(streamIdentifier)
        .map((log) => EventLogDto.fromEventLog(log).toJson())
        .toList();
    return developer.ServiceExtensionResponse.result(
      jsonEncode({EventsConstants.jsonEventLogs: eventLogs}),
    );
  }
}
