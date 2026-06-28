# Changelog

All notable changes to `rxdart_devtools` are documented in this file.

## [0.1.1]

### Changed

- Make published package more readable and easier to understand.

### Documentation

- Full dartdoc coverage across the public API (`sdk.dart` and `dto.dart`).
- Added `example/README.md` covering the three core scenarios — tracking a
  `Stream`, tracking a `Subject`, and tracking a `Subject` with injection
  enabled.

## [0.1.0]

First usable release.

### Added

- `RxDartDevtools.init()` to bootstrap the runtime registry.
- `Stream<T>.track(name)` and `Subject<T>.track(name)` extensions for registering
  streams in the **rxdart** DevTools panel.
- `.enableInjection(parse:)` on tracked subjects to push values in from the panel.
- Panel UI: stream list with live status indicators, current value view, per-stream
  event log, details panel, and clear-all action.
- Serialization of complex values: native JSON types and any class with `toJson()`
  render as a structured tree in the panel; other objects fall back to `toString()`.
- `kReleaseMode` guards on all public entry points; the Dart AOT compiler
  dead-code-eliminates the registry and supporting code from release builds.

## [0.0.1]

- Initial scaffold (never published).
