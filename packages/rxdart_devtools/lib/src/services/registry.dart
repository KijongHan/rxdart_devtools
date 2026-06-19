import 'dart:async';
import 'dart:collection';

import '../devtools/init.dart';
import 'package:uuid/uuid.dart';
import 'types.dart';

class Registry {
  Registry._();

  static final Registry instance = Registry._();

  final Uuid uuid = Uuid();

  final Map<String, TrackedEntry<dynamic>> _entries = {};
  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};

  TrackedEntry<T> register<T>(Stream<T> stream,
      {required String name, int? historySize}) {
    final id = uuid.v4();
    final entry = TrackedEntry<T>(
      id: id,
      name: name,
      typeLabel: stream.runtimeType.toString(),
      historySize: historySize ?? RxDartDevtools.config.historySize,
    );

    final subscription = stream.listen(
      (value) {
        entry.lastValue = value;
        entry.emissionCount++;
        entry.lastEmittedAt = DateTime.now();
      },
      onDone: () {
        entry.isClosed = true;
        entry.closedAt = DateTime.now();
        _subscriptions[id]?.cancel();
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
    _entries[id] = entry;
    return entry;
  }

  Iterable<TrackedEntry<dynamic>> get all => _entries.values;

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
