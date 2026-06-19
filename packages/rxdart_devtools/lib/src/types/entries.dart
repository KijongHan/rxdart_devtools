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

class EntryIdentifier<T> {
  EntryIdentifier(
      {required this.id, required this.name, required this.typeLabel});

  final String id;
  final String name;
  final String typeLabel;
}

class TrackedEntry<T> {
  TrackedEntry({
    required this.entryIdentifier,
    required int historySize,
  }) : history = ListQueue<Emission<T>>(historySize);

  final EntryIdentifier<T> entryIdentifier;

  T? lastValue;
  Object? lastError;
  int emissionCount = 0;
  int listenerCount = 0;
  DateTime? lastEmittedAt;
  ListQueue<Emission<T>> history;
  bool isClosed = false;
  DateTime? closedAt;
}
