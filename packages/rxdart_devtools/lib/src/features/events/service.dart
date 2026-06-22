import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:rxdart_devtools/src/features/events/types.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';

class EventsService {
  final DateTimeProvider _dateTime = getIt.get<DateTimeProvider>();
  final UuidProvider uuidProvider = getIt.get<UuidProvider>();

  final List<BaseEventLog> _eventLogsByTimestamp = [];
  final Map<StreamIdentifier, List<BaseEventLog>> _eventLogsByStream = {};

  void addValueEventLog<T>(StreamIdentifier streamIdentifier, T value) {
    final lastChangeEventLog = _eventLogsByStream[streamIdentifier]
        ?.whereType<ChangeEventLog<T>>()
        .lastOrNull;
    final changeEventLog = ChangeEventLog(
      eventLogIdentifier: EventLogIdentifier(
        id: uuidProvider.generate(),
        timestamp: _dateTime.now(),
      ),
      streamIdentifier: streamIdentifier,
      newValue: value,
      oldValue: lastChangeEventLog?.newValue,
    );
    _eventLogsByTimestamp.add(changeEventLog);
    _eventLogsByStream[streamIdentifier]?.add(changeEventLog);
  }

  void addErrorEventLog(StreamIdentifier streamIdentifier, Object error) {
    final errorEventLog = ErrorEventLog(
      eventLogIdentifier: EventLogIdentifier(
        id: uuidProvider.generate(),
        timestamp: _dateTime.now(),
      ),
      streamIdentifier: streamIdentifier,
      error: error,
    );
    _eventLogsByTimestamp.add(errorEventLog);
    _eventLogsByStream[streamIdentifier]?.add(errorEventLog);
  }

  void registerStream(StreamIdentifier streamIdentifier) {
    final registerEventLog = RegisterEventLog(
      eventLogIdentifier: EventLogIdentifier(
        id: uuidProvider.generate(),
        timestamp: _dateTime.now(),
      ),
      streamIdentifier: streamIdentifier,
    );
    _eventLogsByStream[streamIdentifier] = [registerEventLog];
    _eventLogsByTimestamp.add(registerEventLog);
  }

  void deregisterStream(StreamIdentifier streamIdentifier) {
    final deregisterEventLog = DeregisterEventLog(
      eventLogIdentifier: EventLogIdentifier(
        id: uuidProvider.generate(),
        timestamp: _dateTime.now(),
      ),
      streamIdentifier: streamIdentifier,
    );
    _eventLogsByStream[streamIdentifier]?.add(deregisterEventLog);
    _eventLogsByTimestamp.add(deregisterEventLog);
  }

  Iterable<BaseEventLog> get all => _eventLogsByTimestamp;

  Iterable<BaseEventLog> allForStream(StreamIdentifier streamIdentifier) =>
      _eventLogsByStream[streamIdentifier] ?? [];
}
