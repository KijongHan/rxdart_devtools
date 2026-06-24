import 'dart:convert';
import 'dart:developer' as developer;
import 'package:rxdart_devtools/src/features/events/constants.dart';
import 'package:rxdart_devtools/src/features/events/utils.dart';
import 'package:rxdart_devtools/src/features/events/dto.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/events/types.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/shared/dto.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

final class EventsBackend {
  final eventsService = getIt.get<EventsService>();
  final registryService = getIt.get<RegistryService>();

  EventsBackend() {
    developer.registerExtension(
      EventsConstants.listEventLogs,
      _handleListEventLogs,
    );
  }

  Future<developer.ServiceExtensionResponse> _handleListEventLogs(
    String method,
    Map<String, String> parameters,
  ) async {
    final sortRequest = SortRequestDto.fromJson(parameters);
    final request = ListEventLogsRequestDto.fromJson(parameters);

    final Iterable<BaseEventLog> source;
    if (request.streamId != null) {
      final streamIdentifier =
          registryService.getStreamIdentifier(request.streamId!);
      if (streamIdentifier == null) {
        return developer.ServiceExtensionResponse.error(
          404,
          'Stream not found',
        );
      }
      source = eventsService.allForStream(streamIdentifier);
    } else {
      source = eventsService.all;
    }

    final response = ListEventLogsResponseDto(
      eventLogs: source
          .sortedByRequest(sortRequest)
          .map(EventLogDto.fromEventLog)
          .toList(),
    );
    return developer.ServiceExtensionResponse.result(
      jsonEncode(response.toJson()),
    );
  }
}
