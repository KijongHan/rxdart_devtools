import 'dart:convert';
import 'dart:developer' as developer;
import 'package:collection/collection.dart';
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
    final sortField =
        SortField.fromJson(parameters[EventsConstants.sortField] ?? '');
    final sortDirection = SortDirection.fromJson(
      parameters[EventsConstants.sortDirection] ?? '',
    );

    final eventLogs = [...eventsService.all].sorted((a, b) {
      final (x, y) = sortDirection == SortDirection.ascending ? (a, b) : (b, a);
      return switch (sortField) {
        SortField.timestamp => x.eventLogIdentifier.timestamp
            .compareTo(y.eventLogIdentifier.timestamp),
        SortField.streamId =>
          x.streamIdentifier.id.compareTo(y.streamIdentifier.id),
      };
    }).map((log) => EventLogDto.fromEventLog(log).toJson());

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
