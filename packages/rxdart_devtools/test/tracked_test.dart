import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/rxdart_devtools.dart';

void main() {
  group('Stream.tracked()', () {
    setUp(() {
      RxDartDevtools.init(historySize: 5);
    });

    test('returns the same Subject instance', () {
      final subject = BehaviorSubject<int>.seeded(0);
      final tracked = subject.tracked('counter');
      expect(identical(subject, tracked), isTrue);
    });

    test('is idempotent on repeated calls', () {
      final subject = BehaviorSubject<int>.seeded(0);
      final a = subject.tracked('counter');
      final b = subject.tracked('counter');
      expect(identical(a, b), isTrue);
    });

    test('allows null name (stack-derived fallback)', () {
      final subject = PublishSubject<String>();
      final tracked = subject.tracked(null);
      expect(identical(subject, tracked), isTrue);
    });
  });
}
