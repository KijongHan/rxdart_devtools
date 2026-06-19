import 'dart:collection';

class Emission<T> {
  Emission({
    required this.value,
    required this.timestamp,
    this.isError = false,
  });

  final T? value;
  final DateTime timestamp;
  final bool isError;
}

class TrackedEntry<T> {
  TrackedEntry({
    required this.id,
    required this.name,
    required this.typeLabel,
    required int historySize,
  }) : history = ListQueue<Emission<T>>(historySize);

  final String id;
  final String name;
  final String typeLabel;

  T? lastValue;
  Object? lastError;
  int emissionCount = 0;
  int listenerCount = 0;
  DateTime? lastEmittedAt;
  ListQueue<Emission<T>> history;
  bool isClosed = false;
  DateTime? closedAt;
}
