import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

void main() {
  group('Stream.track()', () {
    setUp(() {
      RxDartDevtools.init(historySize: 5);
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
  });
}
