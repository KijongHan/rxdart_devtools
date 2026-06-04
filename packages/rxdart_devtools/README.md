# rxdart_devtools

A Dart DevTools extension for inspecting RxDart streams.

Tag any `Stream` (including `BehaviorSubject`, `PublishSubject`, plain `StreamController.stream`, or `.map`/`.where` chains) with `.tracked()` and inspect it live in the DevTools "RxDart" tab — last value, listener count, emission count, error state, and a bounded emission history.

## Install

```yaml
dependencies:
  rxdart_devtools: ^0.0.1
```

## Usage

```dart
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/rxdart_devtools.dart';

void main() {
  RxDartDevtools.init(historySize: 20);

  final counter = BehaviorSubject<int>.seeded(0).tracked('counter');
  counter.add(1);
  counter.add(2);

  runApp(const MyApp());
}
```

Open DevTools, attach to your running app, and select the **RxDart** tab.

## Production safety

- `.tracked()` and `RxDartDevtools.init()` are no-ops in release builds (`kReleaseMode`-guarded). The Dart AOT compiler dead-code-eliminates the registry and supporting code.
- The pre-built panel assets ship under `extension/devtools/build/` and are loaded by DevTools at debug time on the host. They are never bundled into your app.

Verify with:

```bash
flutter build appbundle --analyze-size
```

The output should contain no `RxDartDevtools*` symbols.
