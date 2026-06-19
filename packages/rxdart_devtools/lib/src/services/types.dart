import 'dart:collection';

class Emission {
  Emission({
    required this.value,
    required this.timestamp,
    this.isError = false,
  });

  final Object? value;
  final DateTime timestamp;
  final bool isError;
}

class TrackedEntry {
  TrackedEntry({
    required this.id,
    required this.name,
    required this.typeLabel,
    required int historySize,
  }) : history = ListQueue<Emission>(historySize);

  final String id;
  final String name;
  final String typeLabel;

  Object? lastValue;
  Object? lastError;
  int emissionCount = 0;
  int listenerCount = 0;
  DateTime? lastEmittedAt;
  ListQueue<Emission> history;
  bool isClosed = false;
  DateTime? closedAt;
}
