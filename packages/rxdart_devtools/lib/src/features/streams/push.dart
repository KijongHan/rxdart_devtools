import 'dart:developer' as developer;

import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';

final class StreamsPush {
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
