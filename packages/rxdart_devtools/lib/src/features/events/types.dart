import 'package:rxdart_devtools/src/features/streams/types.dart';

class EventLogIdentifier {
  EventLogIdentifier({
    required this.id,
    required this.timestamp,
  });

  final String id;
  final DateTime timestamp;
}

sealed class BaseEventLog {
  BaseEventLog({
    required this.eventLogIdentifier,
    required this.streamIdentifier,
  });

  final EventLogIdentifier eventLogIdentifier;
  final StreamIdentifier streamIdentifier;
}

final class ChangeEventLog<T> extends BaseEventLog {
  ChangeEventLog({
    required super.eventLogIdentifier,
    required super.streamIdentifier,
    required this.newValue,
    required this.oldValue,
  });

  final T newValue;
  final T? oldValue;
}

final class ErrorEventLog extends BaseEventLog {
  ErrorEventLog({
    required super.eventLogIdentifier,
    required super.streamIdentifier,
    required this.error,
  });

  final Object error;
}

final class RegisterEventLog extends BaseEventLog {
  RegisterEventLog({
    required super.eventLogIdentifier,
    required super.streamIdentifier,
  });
}

final class DeregisterEventLog extends BaseEventLog {
  DeregisterEventLog({
    required super.eventLogIdentifier,
    required super.streamIdentifier,
  });
}
