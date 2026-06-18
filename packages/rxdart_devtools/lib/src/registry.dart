import 'dart:async';
import 'dart:collection';

import 'init.dart';
import 'naming.dart';
import 'package:uuid/uuid.dart';

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

class Registry {
  Registry._();

  static final Registry instance = Registry._();

  final Uuid uuid = Uuid();

  final Map<String, TrackedEntry> _entries = {};
  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};
  final Expando<TrackedEntry> _byStream = Expando<TrackedEntry>();

  TrackedEntry register<T>(Stream<T> stream, {String? name, int? historySize}) {
    final existing = _byStream[stream];
    if (existing != null) return existing;

    final resolvedHistory = historySize ?? RxDartDevtools.config.historySize;
    final id = uuid.v4();
    final entry = TrackedEntry(
      id: id,
      name: name ?? Naming.fromStackTrace(stream.runtimeType.toString()),
      typeLabel: stream.runtimeType.toString(),
      historySize: resolvedHistory,
    );

    _entries[entry.id] = entry;
    _byStream[stream] = entry;

    final subscription = stream.listen(
      (value) {
        entry.lastValue = value;
        entry.emissionCount++;
        entry.lastEmittedAt = DateTime.now();
      },
      onDone: () {
        entry.isClosed = true;
        entry.closedAt = DateTime.now();
        _subscriptions.remove(id);
        _entries.remove(id);
      },
      onError: (error, stackTrace) {
        entry.lastError = error;
        entry.emissionCount++;
        entry.lastEmittedAt = DateTime.now();
      },
    );
    _subscriptions[id] = subscription;
    return entry;
  }

  Iterable<TrackedEntry> get all => _entries.values;

  void clearClosed() {
    _entries.removeWhere((_, entry) => entry.isClosed);
  }

  void _resizeHistory(TrackedEntry entry, int newSize) {
    if (entry.history.length <= newSize) {
      entry.history = ListQueue<Emission>.from(entry.history);
      return;
    }
    final trimmed =
        entry.history.toList().sublist(entry.history.length - newSize);
    entry.history = ListQueue<Emission>.from(trimmed);
  }
}
