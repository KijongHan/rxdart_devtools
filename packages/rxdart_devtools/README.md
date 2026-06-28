# rxdart_devtools

A Dart & Flutter DevTools extension for inspecting and debugging RxDart Subjects and Dart Streams. It provides a user friendly UI to see the current value, emission history, and value or error injection.

[![pub package](https://img.shields.io/pub/v/rxdart_devtools.svg)](https://pub.dev/packages/rxdart_devtools)
[![pub points](https://img.shields.io/pub/points/rxdart_devtools)](https://pub.dev/packages/rxdart_devtools/score)
[![pub likes](https://img.shields.io/pub/likes/rxdart_devtools)](https://pub.dev/packages/rxdart_devtools/score)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

![rxdart_devtools panel in action](https://raw.githubusercontent.com/KijongHan/rxdart_devtools/main/assets/panel-demo-subjects.gif)

## Why

Flutter has awesome first class support for Streams, and RxDart is a great extension on top of it that lets you write Reactive code. But, debugging them is currently not easy. `print` ladders inside `.listen` callbacks don't scale when you want to quickly identify a Stream or Subject and have a user friendly UI to see the current value, emission history, and inject values or errors to see how the app responds.

`rxdart_devtools` adds a **RxDart** tab to DevTools that lists every stream you've tagged with `.track('name')`, shows its current value, counts listeners and emissions, and lets you push values *into* injectable subjects without touching app code.

## Install

Install the latest published package:

```bash
flutter pub add rxdart_devtools
```

Or add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  rxdart_devtools: ^0.1.1
```

then fetch it:

```bash
flutter pub get
```

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

void main() {
  RxDartDevtools.init();

  final counter = BehaviorSubject<int>.seeded(0)
      .track('counter')
      .enableInjection(parse: int.tryParse)
      .asSubject();

  counter.add(1);
  counter.add(2);

  runApp(MyApp(counter: counter));
}
```

That's it. `counter` behaves like a normal `BehaviorSubject<int>` everywhere in your app — the tracking is transparent.

## Open the panel

1. Run your app: `flutter run` (any target — mobile, web, desktop)
2. Open DevTools from the terminal (`d` in `flutter run`) or your IDE
3. Click the **rxdart** tab in the DevTools toolbar
4. You'll see `counter` and its current value, ready to inject

If the rxdart tab doesn't appear, your app needs to depend on `rxdart_devtools` (DevTools discovers extensions through dependencies).

## Production safety

`RxDartDevtools.init()` and `.track()` are `kReleaseMode`-guarded no-ops. The Dart AOT compiler dead-code-eliminates the registry and supporting code, so nothing ships in a release build.

## Compatibility

| | Version |
|---|---|
| Dart SDK | `^3.6.0` |
| Flutter | `>=3.27.0` |
| rxdart | `^0.28.0` |
| Platforms | Wherever DevTools runs (mobile, web, desktop) |

## Status

Early release — API may change before 1.0. The panel and tracking surface work end-to-end; injection, complex value rendering, and event history are in place. Edge cases will appear; please file issues.

## Links

- 📖 [Documentation](https://kijonghan.github.io/rxdart_devtools/) — tutorials, how-tos, design notes
- 📚 [API reference](https://pub.dev/documentation/rxdart_devtools/latest/) — generated dartdoc
- 🐛 [Issues](https://github.com/KijongHan/rxdart_devtools/issues)
- 💻 [Source](https://github.com/KijongHan/rxdart_devtools)

## License

[MIT](LICENSE). This is a community project, not affiliated with or endorsed by the rxdart maintainers or ReactiveX.
