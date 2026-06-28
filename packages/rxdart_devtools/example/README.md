# rxdart_devtools example

Three minimal snippets covering the core scenarios. For a runnable Flutter app exercising all of them in one place, see the [example app in the repo root](https://github.com/KijongHan/rxdart_devtools/tree/main/example).

All three snippets assume the package is installed and the runtime has been initialised:

```dart
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

void main() {
  RxDartDevtools.init();
  runApp(const MyApp());
}
```

## 1. Tracking a `Stream`

Surface a derived stream in the DevTools panel — read-only. Useful for outputs of `Rx.combineLatest`, `map`, `switchMap`, or any external source you don't own. Broadcast first so `.track()`'s internal listener doesn't consume the only subscription:

```dart
final a = BehaviorSubject<int>.seeded(0);
final b = BehaviorSubject<int>.seeded(0);

final sum = Rx.combineLatest2<int, int, int>(a, b, (x, y) => x + y)
    .shareValue()
    .track('combineLatest.sum')
    .asStream();

sum.listen(print);
```

## 2. Tracking a `Subject`

Subjects you own — `BehaviorSubject`, `PublishSubject`, `ReplaySubject` — are best tracked via the Subject overload, which preserves the subtype:

```dart
final counter = BehaviorSubject<int>.seeded(0)
    .track('counter')
    .asSubject();

counter.add(1);
counter.add(2);
```

`counter` is a normal `BehaviorSubject<int>` — every `counter.add(...)` shows up in the panel's **Current value** card and **Event log**.

## 3. Tracking a `Subject` with injection enabled

Chain `.enableInjection(parse:)` to let the DevTools panel push values **into** the subject. Useful for triggering edge cases without rebuilding the app:

```dart
final counter = BehaviorSubject<int>.seeded(0)
    .track('counter')
    .enableInjection(parse: int.tryParse)
    .asSubject();
```

The panel surfaces an **Inject** dialog with a **Value / Error** toggle:

- **Value** — runs `parse(rawText)` then `counter.add(...)`.
- **Error** — calls `counter.addError(rawText)`.

Returning `null` from `parse` causes the panel to display a parse error and leaves the subject unchanged.

## Production safety

`RxDartDevtools.init()`, `.track()`, and `.enableInjection()` are all `kReleaseMode` no-ops — safe to leave in production code.
