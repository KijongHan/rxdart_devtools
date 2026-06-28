import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

void main() {
  group('Stream.track()', () {
    setUp(() {
      RxDartDevtools.init();
    });

    test('returns a wrapper exposing the original Subject via asSubject()', () {
      final subject = BehaviorSubject<int>.seeded(0);
      final tracked = subject.track('counter');
      expect(identical(subject, tracked.asSubject()), isTrue);
    });

    test('asSubject() returns the original subject', () {
      final subject = BehaviorSubject<int>.seeded(0);
      final tracked = subject.track('counter');
      expect(identical(subject, tracked.asSubject()), isTrue);
    });

    test('throws ArgumentError if name is empty', () {
      final subject = BehaviorSubject<int>.seeded(0);
      expect(() => subject.track(''), throwsArgumentError);
    });

    test('Subject.track() returns a TrackedSubject with enableInjection', () {
      final subject = BehaviorSubject<int>.seeded(0);
      final tracked = subject.track('counter');
      // Compile-time check: enableInjection is only on TrackedSubject.
      final chained = tracked.enableInjection(parse: int.parse);
      expect(identical(chained.asSubject(), subject), isTrue);
    });

    test('asSubject() preserves the original Subject subtype', () {
      final subject = BehaviorSubject<int>.seeded(7);
      // Static type must be BehaviorSubject<int>, not Subject<int>.
      final BehaviorSubject<int> back = subject.track('counter').asSubject();
      expect(back.value, 7);
    });

    test(
      'enableInjection(parse: int.tryParse) registers an injector that the '
      'RegistryService can drive end-to-end',
      () {
        final subject = BehaviorSubject<int>.seeded(0);
        addTearDown(subject.close);

        final tracked = subject
            .track('enable-injection-end-to-end')
            .enableInjection(parse: int.tryParse);

        expect(tracked.identifier, isNotNull);

        final registry = getIt.get<RegistryService>();
        final ok = registry.inject(tracked.identifier!, '42');

        expect(ok.isSuccess(), isTrue);
        expect(subject.value, 42);

        final bad = registry.inject(tracked.identifier!, 'not-a-number');

        expect(bad.isError(), isTrue);
        expect(subject.value, 42); // unchanged on parse failure
      },
    );
  });
}
