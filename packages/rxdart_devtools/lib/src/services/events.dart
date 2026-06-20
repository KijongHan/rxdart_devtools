import 'package:rxdart_devtools/src/types/events.dart';
import 'package:rxdart_devtools/src/types/streams.dart';
import 'package:uuid/uuid.dart';

class Events {
  Events._();

  final Uuid uuid = Uuid();

  static final Events instance = Events._();

  final List<BaseEventLog> _eventLogsByTimestamp = [];
  final Map<StreamIdentifier, List<BaseEventLog>> _eventLogsByStream = {};

  void addValueEventLog<T>(StreamIdentifier streamIdentifier, T value) {
    final lastChangeEventLog = _eventLogsByStream[streamIdentifier]
        ?.whereType<ChangeEventLog<T>>()
        .lastOrNull;
    final changeEventLog = ChangeEventLog(
      eventLogIdentifier: EventLogIdentifier(
        id: uuid.v4(),
        timestamp: DateTime.now(),
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
        id: uuid.v4(),
        timestamp: DateTime.now(),
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
        id: uuid.v4(),
        timestamp: DateTime.now(),
      ),
      streamIdentifier: streamIdentifier,
    );
    _eventLogsByStream[streamIdentifier] = [registerEventLog];
    _eventLogsByTimestamp.add(registerEventLog);
  }

  void deregisterStream(StreamIdentifier streamIdentifier) {
    final deregisterEventLog = DeregisterEventLog(
      eventLogIdentifier: EventLogIdentifier(
        id: uuid.v4(),
        timestamp: DateTime.now(),
      ),
      streamIdentifier: streamIdentifier,
    );
    _eventLogsByStream[streamIdentifier] = [deregisterEventLog];
    _eventLogsByTimestamp.add(deregisterEventLog);
  }
}
