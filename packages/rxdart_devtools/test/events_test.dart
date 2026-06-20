import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart_devtools/src/services/events.dart';
import 'package:rxdart_devtools/src/types/events.dart';
import 'package:rxdart_devtools/src/types/streams.dart';
import 'package:uuid/uuid.dart';

void main() {
  final events = GetIt.I.get<EventsService>();
  const uuid = Uuid();

  StreamIdentifier newIdentifier() => StreamIdentifier(
        id: uuid.v4(),
        name: 'test-stream',
        typeLabel: 'Stream<int>',
      );

  List<BaseEventLog> logsFor(StreamIdentifier id) =>
      events.all.where((e) => e.streamIdentifier == id).toList();

  group('Events.registerStream', () {
    test('appends a RegisterEventLog', () {
      final id = newIdentifier();
      events.registerStream(id);
      final logs = logsFor(id);
      expect(logs, hasLength(1));
      expect(logs.single, isA<RegisterEventLog>());
    });

    test('assigns a unique id and current timestamp', () {
      final id = newIdentifier();
      final before = DateTime.now();
      events.registerStream(id);
      final after = DateTime.now();
      final log = logsFor(id).single;
      expect(log.eventLogIdentifier.id, isNotEmpty);
      expect(
        log.eventLogIdentifier.timestamp
            .isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        log.eventLogIdentifier.timestamp
            .isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });
  });

  group('Events.addValueEventLog', () {
    test(
        'records a ChangeEventLog with the new value and null oldValue on first call',
        () {
      final id = newIdentifier();
      events.registerStream(id);
      events.addValueEventLog<int>(id, 42);
      final change = logsFor(id).whereType<ChangeEventLog<int>>().single;
      expect(change.newValue, 42);
      expect(change.oldValue, isNull);
    });

    test('chains oldValue from the previous ChangeEventLog', () {
      final id = newIdentifier();
      events.registerStream(id);
      events.addValueEventLog<int>(id, 1);
      events.addValueEventLog<int>(id, 2);
      events.addValueEventLog<int>(id, 3);
      final changes = logsFor(id).whereType<ChangeEventLog<int>>().toList();
      expect(changes.map((c) => c.oldValue).toList(), [null, 1, 2]);
      expect(changes.map((c) => c.newValue).toList(), [1, 2, 3]);
    });

    test('skips non-Change logs when computing oldValue', () {
      final id = newIdentifier();
      events.registerStream(id);
      events.addValueEventLog<int>(id, 10);
      events.addErrorEventLog(id, 'boom');
      events.addValueEventLog<int>(id, 20);
      final changes = logsFor(id).whereType<ChangeEventLog<int>>().toList();
      expect(changes[1].oldValue, 10);
      expect(changes[1].newValue, 20);
    });
  });

  group('Events.addErrorEventLog', () {
    test('appends an ErrorEventLog with the error', () {
      final id = newIdentifier();
      events.registerStream(id);
      events.addErrorEventLog(id, 'boom');
      final last = logsFor(id).last;
      expect(last, isA<ErrorEventLog>());
      expect((last as ErrorEventLog).error, 'boom');
    });
  });

  group('Events.deregisterStream', () {
    test('appends a DeregisterEventLog to the global timestamp list', () {
      final id = newIdentifier();
      events.registerStream(id);
      events.addValueEventLog<int>(id, 1);
      events.deregisterStream(id);
      final last = events.all.where((e) => e.streamIdentifier == id).last;
      expect(last, isA<DeregisterEventLog>());
    });
  });

  group('Events.all', () {
    test('returns logs in insertion order', () {
      final id = newIdentifier();
      events.registerStream(id);
      events.addValueEventLog<int>(id, 1);
      events.addErrorEventLog(id, 'e');
      events.deregisterStream(id);
      final ordered = logsFor(id);
      expect(ordered[0], isA<RegisterEventLog>());
      expect(ordered[1], isA<ChangeEventLog<int>>());
      expect(ordered[2], isA<ErrorEventLog>());
      expect(ordered[3], isA<DeregisterEventLog>());
    });
  });
}
