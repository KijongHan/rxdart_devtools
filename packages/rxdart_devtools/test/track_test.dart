import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

void main() {
  group('Stream.track()', () {
    setUp(() {
      RxDartDevtools.init(historySize: 5);
    });

    test('returns the same Subject instance', () {
      final subject = BehaviorSubject<int>.seeded(0);
      final tracked = subject.track('counter');
      expect(identical(subject, tracked), isTrue);
    });

    test('is idempotent on repeated calls', () {
      final subject = BehaviorSubject<int>.seeded(0);
      final a = subject.track('counter');
      final b = subject.track('counter');
      expect(identical(a, b), isTrue);
    });

    test('throws ArgumentError if name is empty', () {
      final subject = BehaviorSubject<int>.seeded(0);
      expect(() => subject.track(''), throwsArgumentError);
    });
  });
}
