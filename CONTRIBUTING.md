# Contributing to rxdart_devtools

## Repo layout

```
rxdart_devtools/                       # workspace root
├── packages/
│   ├── rxdart_devtools/               # published runtime package
│   └── rxdart_devtools_extension/     # Flutter web panel (publish_to: none)
├── example/                           # dogfood Flutter app
└── tool/
    └── build_panel.dart               # build panel into runtime package
```

Only `packages/rxdart_devtools/` is published. The panel and example are workspace siblings — they never enter a consumer's dependency graph.

## Prerequisites

- Dart SDK `^3.6.0` (required for Dart workspaces)
- Flutter SDK `>=3.27.0`
- `melos` (optional but recommended):

  ```bash
  dart pub global activate melos
  ```

  If `melos` isn't on your PATH afterwards, add the pub cache bin directory to your shell profile:

  ```bash
  export PATH="$PATH:$HOME/.pub-cache/bin"
  ```

## Bootstrap

```bash
flutter pub get        # resolves all workspace packages via the root pubspec
melos bootstrap        # optional; same effect plus runs configured hooks
```

## Local development workflow

The recommended loop uses the `devtools_extensions` package's **simulated DevTools environment**. The panel runs as a regular Flutter web app with full hot reload and connects to a real running target app over the VM service. No need to rebuild the panel after every change.

### Two-process setup

Open two terminals.

**Terminal 1 — run the example app:**

```bash
melos run dev:example:chrome      # web (Chrome)
melos run dev:example:android     # connected Android device or emulator
# or, manually for other targets:
cd example && flutter run -d <id>     # see `flutter devices`
```

Note the printed VM service URI, e.g.:

```
A Dart VM Service on macOS is available at: http://127.0.0.1:54321/abcDEF=/
```

**Terminal 2 — run the panel in the simulator:**

```bash
melos run dev:panel
# or, manually:
cd packages/rxdart_devtools_extension
flutter run -d chrome --dart-define=use_simulated_environment=true
```

Chrome opens a simulator shell wrapping the panel. Paste the URI from Terminal 1 into the simulator's text field. The panel connects, polls `ext.rxdart.list`, and renders tracked streams.

### What hot-reloads where

Press `r` in the relevant terminal:

| Edit | Reload in |
|---|---|
| Panel widgets, controllers, theming (`packages/rxdart_devtools_extension/lib/**`) | Terminal 2 (Chrome) |
| Runtime registry, `.track()`, service extension (`packages/rxdart_devtools/lib/src/**`) | Terminal 1 (example) |
| Wire DTOs (`packages/rxdart_devtools/lib/src/wire/**`) | **Both** — runtime serializes, panel deserializes |
| `extension/devtools/config.yaml` | Irrelevant in simulator mode |

The runtime edits hot-reload in the example app because `example` path-deps on `rxdart_devtools` through the Dart workspace.

## Testing against real DevTools

Use this only when you need to verify the production discovery flow (pre-publish smoke test, `config.yaml` validation, real-DevTools shell integration):

```bash
dart tool/build_panel.dart            # or: melos run build_panel
cd example && flutter run
```

Then open DevTools (press `v` in the `flutter run` terminal, or open the DevTools URL it prints). The "RxDart" tab should appear because DevTools walks the example app's dep graph and finds `extension/devtools/config.yaml` via the local `path:` resolution of `rxdart_devtools`.

Do not use this loop for ordinary panel iteration — every change requires a full rebuild and copy.

## Tests, format, analyze

```bash
melos run test         # unit tests across packages with a test/ directory
melos run analyze      # dart analyze across the workspace
melos run format       # dart format .
```

## Code generation

Wire DTOs in `packages/rxdart_devtools/lib/src/dto/` use `json_serializable`. Generated `*.g.dart` siblings are committed.

Regenerate after adding or changing any `@JsonSerializable` class:

```bash
cd packages/rxdart_devtools
dart run build_runner build       # one-shot
dart run build_runner watch       # rebuild on save
```

## Conventions

### `kReleaseMode` guards on public entry points

Every public entry point in `package:rxdart_devtools` must begin with a `kReleaseMode` guard so the Dart AOT compiler dead-code-eliminates the debug-only machinery from consumers' release builds:

```dart
Stream<T> track(String? name, {int? historySize}) {
  if (kReleaseMode) return this;
  return impl.trackImpl(this, name, historySize);
}
```

This applies to `Stream<T>.track`, `RxDartDevtools.init`, and any future public surface that touches the registry, lifecycle hooks, service extensions, or stack-derived naming.

### Wire DTOs are shared via the runtime package

Wire types live at `packages/rxdart_devtools/lib/src/wire/` and are re-exported via `packages/rxdart_devtools/lib/wire.dart`. The panel imports them through its `path: ../rxdart_devtools` dev-dependency. Do not duplicate DTOs in the panel package.

### Built panel output is not committed

`packages/rxdart_devtools/extension/devtools/build/` is `.gitignore`d. The directory is populated by `tool/build_panel.dart` at publish time.

### `config.yaml` version tracks the runtime package

Keep `packages/rxdart_devtools/extension/devtools/config.yaml`'s `version` field in sync with `packages/rxdart_devtools/pubspec.yaml`'s `version` on every release.
