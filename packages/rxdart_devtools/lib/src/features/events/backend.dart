import 'dart:convert';
import 'dart:developer' as developer;
import 'package:rxdart_devtools/src/features/events/constants.dart';
import 'package:rxdart_devtools/src/features/events/dto.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/providers/get_it.dart';

final class EventsBackend {
  final eventsService = getIt.get<EventsService>();

  EventsBackend() {
    developer.registerExtension(
        EventsConstants.listEventLogs, _handleListEventLogs);
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
}
