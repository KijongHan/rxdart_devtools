import 'package:rxdart_devtools/src/types/streams.dart';

class EventLogIdentifier {
  EventLogIdentifier({
    required this.id,
    required this.timestamp,
    required this.type,
  });

  final String id;
  final DateTime timestamp;
  final String type;
}

abstract class BaseEventLog<T> {
  BaseEventLog({
    required this.eventLogIdentifier,
    required this.streamIdentifier,
  });

  final EventLogIdentifier eventLogIdentifier;
  final StreamIdentifier streamIdentifier;
}

class ChangeEventLog<T> extends BaseEventLog<T> {
  ChangeEventLog({
    required super.eventLogIdentifier,
    required super.streamIdentifier,
    required this.newValue,
    required this.oldValue,
  });

  final T newValue;
  final T oldValue;
}

class AddEventLog<T> extends BaseEventLog<T> {
  AddEventLog(
      {required super.eventLogIdentifier,
      required super.streamIdentifier,
      required this.value});

  final T value;
}

class RemoveEventLog<T> extends BaseEventLog<T> {
  RemoveEventLog({
    required super.eventLogIdentifier,
    required super.streamIdentifier,
    required this.value,
  });

  final T value;
}
