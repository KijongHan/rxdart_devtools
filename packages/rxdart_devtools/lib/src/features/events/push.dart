import 'dart:developer' as developer;

import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools/src/features/events/types.dart';

final class EventsPush {
  void postEventAdded(BaseEventLog eventLog) {
    developer.postEvent(
      EventsConstants.eventAdded,
      EventLogAddedEventDto(
        streamId: eventLog.streamIdentifier.id,
        eventLog: EventLogDto.fromEventLog(eventLog),
      ).toJson(),
    );
  }
}
