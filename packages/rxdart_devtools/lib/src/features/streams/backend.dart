import 'dart:convert';
import 'dart:developer' as developer;

import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:rxdart_devtools/src/features/streams/service.dart';
import 'package:rxdart_devtools/src/features/streams/dto.dart';
import 'constants.dart';

final class StreamsBackend {
  final streamsService = getIt.get<StreamsService>();

  StreamsBackend() {
    developer.registerExtension(
        StreamsConstants.listStreamEntries, _handleListStreamEntries);
    developer.registerExtension(
        StreamsConstants.clearClosed, _handleClearClosed);
  }

  Future<developer.ServiceExtensionResponse> _handleListStreamEntries(
    String method,
    Map<String, String> parameters,
  ) async {
    final response = ListStreamEntriesResponseDto(
      entries: streamsService.all.map(StreamEntryDto.fromEntry).toList(),
    );
    return developer.ServiceExtensionResponse.result(
      jsonEncode(response.toJson()),
    );
  }

  Future<developer.ServiceExtensionResponse> _handleClearClosed(
    String method,
    Map<String, String> parameters,
  ) async {
    streamsService.clearClosed();
    return developer.ServiceExtensionResponse.result(jsonEncode({'ok': true}));
  }

  void postStreamRegistered(StreamIdentifier identifier) {
    developer.postEvent(
      StreamsConstants.streamRegistered,
      StreamEventDto(streamId: identifier.id).toJson(),
    );
  }

  void postStreamClosed(StreamIdentifier identifier) {
    developer.postEvent(
      StreamsConstants.streamClosed,
      StreamEventDto(streamId: identifier.id).toJson(),
    );
  }

  void postStreamUpdated(
    StreamEntry<dynamic> entry,
  ) {
    developer.postEvent(
      StreamsConstants.streamUpdated,
      StreamUpdatedEventDto(
        streamId: entry.entryIdentifier.id,
        entry: StreamEntryDto.fromEntry(entry),
      ).toJson(),
    );
  }

  void postStreamErrored(StreamEntry<dynamic> entry) {
    developer.postEvent(
      StreamsConstants.streamErrored,
      StreamUpdatedEventDto(
        streamId: entry.entryIdentifier.id,
        entry: StreamEntryDto.fromEntry(entry),
      ).toJson(),
    );
  }
}
