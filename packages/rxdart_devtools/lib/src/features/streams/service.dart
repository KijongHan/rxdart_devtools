import 'package:rxdart_devtools/src/features/streams/backend.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';

class StreamsService {
  final _dateTime = getIt.get<DateTimeProvider>();
  final _backend = getIt.get<StreamsBackend>();

  final Map<StreamIdentifier, StreamEntry<dynamic>> _entries = {};

  StreamEntry<dynamic> registerStream<T>(
    StreamIdentifier identifier, {
    StreamData<T>? data,
  }) {
    final newEntry = StreamEntry<T>(
      entryIdentifier: identifier,
      metadata: StreamMetadata(
        listenerCount: 0,
        lastEmittedAt: null,
        isClosed: false,
        closedAt: null,
      ),
      data: data,
    );
    _entries[identifier] = newEntry;
    _backend.postStreamRegistered(identifier);
    return newEntry;
  }

  StreamEntry<dynamic> updateValue<T>(StreamIdentifier identifier, T value) {
    final currentEntry = _entries[identifier];
    final newEntry = currentEntry?.copyWith(
          metadata: currentEntry.metadata.copyWith(
            lastEmittedAt: _dateTime.now(),
          ),
          data: StreamData(lastValue: value, lastError: null),
        ) ??
        registerStream<T>(identifier,
            data: StreamData(lastValue: value, lastError: null));
    _entries[identifier] = newEntry;
    _backend.postStreamUpdated(newEntry);
    return newEntry;
  }

  StreamEntry<dynamic> updateError(StreamIdentifier identifier, Object error) {
    final currentEntry = _entries[identifier];
    final newEntry = currentEntry?.copyWith(
          data: StreamData(lastValue: null, lastError: error),
          metadata: currentEntry.metadata.copyWith(
            lastEmittedAt: _dateTime.now(),
          ),
        ) ??
        registerStream<dynamic>(identifier,
            data: StreamData(lastValue: null, lastError: error));
    _entries[identifier] = newEntry;
    _backend.postStreamUpdated(newEntry);
    return newEntry;
  }

  void deregisterStream(StreamIdentifier identifier) {
    final currentEntry = _entries[identifier];
    if (currentEntry == null) return;
    final newEntry = currentEntry.copyWith(
      metadata: currentEntry.metadata.copyWith(
        isClosed: true,
        closedAt: _dateTime.now(),
      ),
    );
    _entries[identifier] = newEntry;
    _backend.postStreamClosed(identifier);
  }

  void clearClosed() {
    _entries.removeWhere((_, entry) => entry.metadata.isClosed);
  }

  Iterable<StreamEntry<dynamic>> get all => _entries.values;
}
