import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart_devtools/src/services/streams.dart';
import 'package:rxdart_devtools/src/types/streams.dart';
import 'package:uuid/uuid.dart';

void main() {
  final streams = GetIt.I.get<StreamsService>();
  const uuid = Uuid();

  StreamIdentifier newIdentifier() => StreamIdentifier(
        id: uuid.v4(),
        name: 'test-stream',
        typeLabel: 'Stream<int>',
      );

  StreamEntry<dynamic> storedFor(StreamIdentifier id) =>
      streams.all.firstWhere((e) => e.entryIdentifier == id);

  group('Streams.registerStream', () {
    test('creates an entry with the given identifier', () {
      final id = newIdentifier();
      final entry = streams.registerStream<int>(id);
      expect(entry.entryIdentifier, id);
    });

    test('initializes metadata to defaults', () {
      final id = newIdentifier();
      final entry = streams.registerStream<int>(id);
      expect(entry.metadata.emissionCount, 0);
      expect(entry.metadata.listenerCount, 0);
      expect(entry.metadata.lastEmittedAt, isNull);
      expect(entry.metadata.isClosed, isFalse);
      expect(entry.metadata.closedAt, isNull);
    });

    test('leaves data null when no data is supplied', () {
      final id = newIdentifier();
      final entry = streams.registerStream<int>(id);
      expect(entry.data, isNull);
    });

    test('respects an initial data argument', () {
      final id = newIdentifier();
      final entry = streams.registerStream<int>(
        id,
        data: StreamData<int>(lastValue: 100, lastError: null),
      );
      expect(entry.data?.lastValue, 100);
    });
  });

  group('Streams.updateValue', () {
    test('increments emissionCount on each call', () {
      final id = newIdentifier();
      streams.registerStream<dynamic>(id);
      streams.updateValue<dynamic>(id, 1);
      streams.updateValue<dynamic>(id, 2);
      expect(storedFor(id).metadata.emissionCount, 2);
    });

    test('sets lastEmittedAt', () {
      final id = newIdentifier();
      streams.registerStream<dynamic>(id);
      streams.updateValue<dynamic>(id, 1);
      expect(storedFor(id).metadata.lastEmittedAt, isNotNull);
    });

    test('sets data.lastValue on an existing entry', () {
      final id = newIdentifier();
      streams.registerStream<dynamic>(id);
      streams.updateValue<dynamic>(id, 42);
      expect(storedFor(id).data?.lastValue, 42);
    });

    test('overwrites a previously set lastValue', () {
      final id = newIdentifier();
      streams.registerStream<dynamic>(
        id,
        data: StreamData<dynamic>(lastValue: 1, lastError: null),
      );
      streams.updateValue<dynamic>(id, 99);
      expect(storedFor(id).data?.lastValue, 99);
    });

    test('on a fresh identifier creates the entry via the fallback path', () {
      final id = newIdentifier();
      streams.updateValue<dynamic>(id, 7);
      // Fallback path goes through registerStream, which sets data and
      // initializes metadata fresh (so emissionCount is 0, not 1).
      expect(storedFor(id).data?.lastValue, 7);
    });

    test('supports a concrete generic when entry was registered as <dynamic>',
        () {
      // FAILS: see todo--streams-update-value-bugs (#4).
      // `newEntry as StreamEntry<T>` casts a StreamEntry<dynamic> to
      // StreamEntry<int>, which throws _TypeError under Dart's reified generics.
      final id = newIdentifier();
      streams.registerStream<dynamic>(id);
      expect(() => streams.updateValue<int>(id, 42), returnsNormally);
    });
  });

  group('Streams.updateError', () {
    test('increments emissionCount on an existing entry', () {
      final id = newIdentifier();
      streams.registerStream<dynamic>(id);
      streams.updateError(id, 'boom');
      expect(storedFor(id).metadata.emissionCount, 1);
    });

    test('records error on existing entry data', () {
      final id = newIdentifier();
      streams.registerStream<dynamic>(
        id,
        data: StreamData<dynamic>(lastValue: 1, lastError: null),
      );
      streams.updateError(id, 'boom');
      expect(storedFor(id).data?.lastError, 'boom');
    });

    test('on a fresh identifier creates an entry with the error', () {
      final id = newIdentifier();
      streams.updateError(id, 'boom');
      expect(storedFor(id).data?.lastError, 'boom');
    });
  });

  group('Streams.deregisterStream', () {
    test('marks isClosed and sets closedAt', () {
      final id = newIdentifier();
      streams.registerStream<int>(id);
      streams.deregisterStream(id);
      final stored = storedFor(id);
      expect(stored.metadata.isClosed, isTrue);
      expect(stored.metadata.closedAt, isNotNull);
    });

    test('is a no-op for an unknown identifier', () {
      final id = newIdentifier();
      streams.deregisterStream(id); // never registered
      expect(
        streams.all.where((e) => e.entryIdentifier == id),
        isEmpty,
      );
    });
  });

  group('Streams.clearClosed', () {
    test('removes closed entries and leaves open ones', () {
      final openId = newIdentifier();
      final closedId = newIdentifier();
      streams.registerStream<int>(openId);
      streams.registerStream<int>(closedId);
      streams.deregisterStream(closedId);
      streams.clearClosed();
      expect(
        streams.all.where((e) => e.entryIdentifier == closedId),
        isEmpty,
      );
      expect(
        streams.all.where((e) => e.entryIdentifier == openId),
        isNotEmpty,
      );
    });
  });
}
