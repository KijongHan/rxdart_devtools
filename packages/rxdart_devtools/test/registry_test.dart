import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart_devtools/src/features/config/providers.dart';
import 'package:rxdart_devtools/src/features/config/types.dart';
import 'package:rxdart_devtools/src/features/events/push.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/events/types.dart';
import 'package:rxdart_devtools/src/features/registry/providers.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/features/streams/push.dart';
import 'package:rxdart_devtools/src/features/streams/service.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

void main() {
  late RegistryService registry;
  late StreamsService streams;
  late EventsService events;

  setUp(() {
    getIt.registerSingleton(
      ConfigProvider(config: const SdkConfig()),
    );
    getIt.registerSingleton(DateTimeProvider());
    getIt.registerSingleton(UuidProvider());
    getIt.registerSingleton(StreamIdentifierProvider());
    getIt.registerSingleton(StreamsPush());
    getIt.registerSingleton(EventsPush());
    getIt.registerSingleton(StreamsService());
    getIt.registerSingleton(EventsService());
    getIt.registerSingleton(RegistryService());

    registry = getIt.get<RegistryService>();
    streams = getIt.get<StreamsService>();
    events = getIt.get<EventsService>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  ({StreamController<int> controller, String id}) registerNew({
    String name = 'test-stream',
  }) {
    final controller = StreamController<int>.broadcast();
    registry.register(controller.stream, (name: name, historySize: null));
    return (controller: controller, id: name);
  }

  group('Registry.register', () {
    test('makes the stream identifier resolvable via getStreamIdentifier', () {
      final reg = registerNew(name: 'counter');
      addTearDown(reg.controller.close);
      expect(registry.getStreamIdentifier(reg.id), isNotNull);
    });

    test('registers the stream with StreamsService', () {
      final reg = registerNew(name: 'counter');
      addTearDown(reg.controller.close);
      final identifier = registry.getStreamIdentifier(reg.id)!;
      expect(
        streams.all.where((e) => e.entryIdentifier == identifier),
        hasLength(1),
      );
    });

    test('records a RegisterEventLog in EventsService', () {
      final reg = registerNew(name: 'counter');
      addTearDown(reg.controller.close);
      final identifier = registry.getStreamIdentifier(reg.id)!;
      expect(
        events.allForStream(identifier).whereType<RegisterEventLog>(),
        hasLength(1),
      );
    });

    test('forwards emitted values to StreamsService.updateValue', () async {
      final reg = registerNew(name: 'counter');
      addTearDown(reg.controller.close);
      final identifier = registry.getStreamIdentifier(reg.id)!;

      reg.controller.add(42);
      await Future<void>.delayed(Duration.zero);

      final stored = streams.all.firstWhere(
        (e) => e.entryIdentifier == identifier,
      );
      expect(stored.data?.lastValue, 42);
    });

    test('forwards emitted values as ChangeEventLog in EventsService',
        () async {
      final reg = registerNew(name: 'counter');
      addTearDown(reg.controller.close);
      final identifier = registry.getStreamIdentifier(reg.id)!;

      reg.controller.add(1);
      reg.controller.add(2);
      await Future<void>.delayed(Duration.zero);

      final changes = events
          .allForStream(identifier)
          .whereType<ChangeEventLog<int>>()
          .toList();
      expect(changes.map((c) => c.newValue), [1, 2]);
    });

    test('forwards errors to StreamsService.updateError', () async {
      final reg = registerNew(name: 'counter');
      addTearDown(reg.controller.close);
      final identifier = registry.getStreamIdentifier(reg.id)!;

      reg.controller.addError('boom');
      await Future<void>.delayed(Duration.zero);

      final stored = streams.all.firstWhere(
        (e) => e.entryIdentifier == identifier,
      );
      expect(stored.data?.lastError, 'boom');
    });

    test('forwards errors as ErrorEventLog in EventsService', () async {
      final reg = registerNew(name: 'counter');
      addTearDown(reg.controller.close);
      final identifier = registry.getStreamIdentifier(reg.id)!;

      reg.controller.addError('boom');
      await Future<void>.delayed(Duration.zero);

      final errors =
          events.allForStream(identifier).whereType<ErrorEventLog>().toList();
      expect(errors, hasLength(1));
      expect(errors.single.error, 'boom');
    });

    test('on stream close, deregisters in StreamsService and EventsService',
        () async {
      final reg = registerNew(name: 'counter');
      final identifier = registry.getStreamIdentifier(reg.id)!;

      await reg.controller.close();
      await Future<void>.delayed(Duration.zero);

      final stored = streams.all.firstWhere(
        (e) => e.entryIdentifier == identifier,
      );
      expect(stored.metadata.isClosed, isTrue);
      expect(
        events.allForStream(identifier).whereType<DeregisterEventLog>(),
        hasLength(1),
      );
    });
  });

  group('Registry.getStreamIdentifier', () {
    test('returns null for an unknown id', () {
      expect(registry.getStreamIdentifier('nope'), isNull);
    });
  });

  group('Registry.clear', () {
    test('removes all identifiers', () async {
      final a = registerNew(name: 'a');
      final b = registerNew(name: 'b');
      addTearDown(a.controller.close);
      addTearDown(b.controller.close);

      await registry.clear();

      expect(registry.getStreamIdentifier(a.id), isNull);
      expect(registry.getStreamIdentifier(b.id), isNull);
    });

    test('cancels subscriptions so subsequent emissions are ignored', () async {
      final reg = registerNew(name: 'counter');
      addTearDown(reg.controller.close);
      final identifier = registry.getStreamIdentifier(reg.id)!;

      await registry.clear();

      reg.controller.add(99);
      await Future<void>.delayed(Duration.zero);

      // No ChangeEventLog was appended after clear because the
      // subscription was cancelled.
      expect(
        events.allForStream(identifier).whereType<ChangeEventLog<int>>(),
        isEmpty,
      );
    });

    test('is idempotent', () async {
      registerNew(name: 'counter');
      await registry.clear();
      await registry.clear();
      expect(registry.getStreamIdentifier('counter'), isNull);
    });
  });
}
