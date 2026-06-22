import 'dart:convert';
import 'dart:developer' as developer;
import 'package:rxdart_devtools/src/features/events/constants.dart';
import 'package:rxdart_devtools/src/features/events/utils.dart';
import 'package:rxdart_devtools/src/features/events/dto.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/shared/dto.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

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
    final sortRequest = SortRequestDto.fromJson(parameters);

    final response = ListEventLogsResponseDto(
      eventLogs: eventsService.all
          .sortedByRequest(sortRequest)
          .map(EventLogDto.fromEventLog)
          .toList(),
    );
    return developer.ServiceExtensionResponse.result(
      jsonEncode(response.toJson()),
    );
  }

  Future<developer.ServiceExtensionResponse> _handleListStreamEventLogs(
    String method,
    Map<String, String> parameters,
  ) async {
    final sortRequest = SortRequestDto.fromJson(parameters);
    final listStreamEventLogsRequest =
        ListStreamEventLogsRequestDto.fromJson(parameters);

    final streamIdentifier = registryService
        .getStreamIdentifier(listStreamEventLogsRequest.streamId);
    if (streamIdentifier == null) {
      return developer.ServiceExtensionResponse.error(
        404,
        'Stream not found',
      );
    }

    final response = ListEventLogsResponseDto(
      eventLogs: eventsService
          .allForStream(streamIdentifier)
          .sortedByRequest(sortRequest)
          .map(EventLogDto.fromEventLog)
          .toList(),
    );
    return developer.ServiceExtensionResponse.result(
      jsonEncode(response.toJson()),
    );
  }
}
