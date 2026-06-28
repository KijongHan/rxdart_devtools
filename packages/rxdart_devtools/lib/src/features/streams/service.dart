// ignore_for_file: public_member_api_docs

import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/features/streams/push.dart';

class StreamsService {
  final _dateTime = getIt.get<DateTimeProvider>();
  final _push = getIt.get<StreamsPush>();

  final Map<StreamIdentifier, StreamEntry<dynamic>> _entries = {};

  StreamEntry<dynamic> registerStream<T>(
    StreamIdentifier identifier, {
    bool isSubject = false,
    StreamData<T>? data,
  }) {
    final newEntry = StreamEntry<T>(
      entryIdentifier: identifier,
      metadata: StreamMetadata(
        listenerCount: 0,
        lastEmittedAt: null,
        isClosed: false,
        closedAt: null,
        isSubject: isSubject,
      ),
      data: data,
    );
    _entries[identifier] = newEntry;
    _push.postStreamRegistered(identifier);
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
        registerStream<T>(
          identifier,
          data: StreamData(lastValue: value, lastError: null),
        );
    _entries[identifier] = newEntry;
    _push.postStreamUpdated(newEntry);
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
        registerStream<dynamic>(
          identifier,
          data: StreamData(lastValue: null, lastError: error),
        );
    _entries[identifier] = newEntry;
    _push.postStreamErrored(newEntry);
    return newEntry;
  }

  void markInjectable(StreamIdentifier identifier) {
    final currentEntry = _entries[identifier];
    if (currentEntry == null) return;
    final newEntry = currentEntry.copyWith(
      metadata: currentEntry.metadata.copyWith(
        isInjectable: true,
        isSubject: true,
      ),
    );
    _entries[identifier] = newEntry;
    _push.postStreamUpdated(newEntry);
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
    _push.postStreamClosed(identifier);
  }

  void clear() {
    _entries.clear();
  }

  Iterable<StreamEntry<dynamic>> get all => _entries.values;
}