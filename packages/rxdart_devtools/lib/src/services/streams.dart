import 'package:rxdart_devtools/src/types/streams.dart';

class Streams {
  Streams._();

  static final Streams instance = Streams._();

  final Map<StreamIdentifier, StreamEntry<dynamic>> _entries = {};

  StreamEntry<T> insertEntry<T>(
    StreamIdentifier identifier, {
    StreamData<T>? data,
  }) {
    final newEntry = StreamEntry<T>(
      entryIdentifier: identifier,
      metadata: StreamMetadata(
        emissionCount: 0,
        listenerCount: 0,
        lastEmittedAt: null,
        isClosed: false,
        closedAt: null,
      ),
      data: data,
    );
    _entries[identifier] = newEntry;
    return newEntry;
  }

  StreamEntry<T> updateValue<T>(StreamIdentifier identifier, T value) {
    final currentEntry = _entries[identifier];
    final newEntry = currentEntry?.copyWith(
          metadata: currentEntry.metadata.copyWith(
            emissionCount: currentEntry.metadata.emissionCount + 1,
            lastEmittedAt: DateTime.now(),
          ),
          data: currentEntry.data?.copyWith(lastValue: value, lastError: null),
        ) ??
        insertEntry<T>(identifier,
            data: StreamData(lastValue: value, lastError: null));
    _entries[identifier] = newEntry;
    return newEntry as StreamEntry<T>;
  }

  StreamEntry<dynamic> updateError(StreamIdentifier identifier, Object error) {
    final currentEntry = _entries[identifier];
    final newEntry = currentEntry?.copyWith(
          metadata: currentEntry.metadata.copyWith(
            emissionCount: currentEntry.metadata.emissionCount + 1,
            lastEmittedAt: DateTime.now(),
          ),
        ) ??
        insertEntry<dynamic>(identifier,
            data: StreamData(lastValue: null, lastError: error));
    _entries[identifier] = newEntry;
    return newEntry;
  }

  void remove(StreamIdentifier identifier) {
    final currentEntry = _entries[identifier];
    if (currentEntry == null) return;
    final newEntry = currentEntry.copyWith(
      metadata: currentEntry.metadata.copyWith(
        isClosed: true,
        closedAt: DateTime.now(),
      ),
    );
    _entries[identifier] = newEntry;
  }

  void clearClosed() {
    _entries.removeWhere((_, entry) => entry.metadata.isClosed);
  }

  Iterable<StreamEntry<dynamic>> get all => _entries.values;
}
