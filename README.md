# rxdart_devtools

A Dart DevTools extension for inspecting RxDart streams.

## Repo layout

```
rxdart_devtools/                       # workspace root
├── packages/
│   ├── rxdart_devtools/               # published runtime package
│   └── rxdart_devtools_extension/     # Flutter web panel (not published)
├── example/                           # dogfood Flutter app
└── tool/
    └── build_panel.dart               # build the panel into the runtime package
```

## Getting started

Requires Dart SDK ^3.6.0 (for workspaces) and the Flutter SDK.

```bash
flutter pub get                        # resolves all workspace packages
melos bootstrap                        # optional, if using melos
```

## Developing the panel

Run the panel against a simulated DevTools environment:

```bash
cd packages/rxdart_devtools_extension
flutter run -d chrome --dart-define=use_simulated_environment=true
```

## Building the panel for release

```bash
dart tool/build_panel.dart
```

Output lands in `packages/rxdart_devtools/extension/devtools/build/`, which ships with the runtime package on pub.

## Status

Scaffold only. The runtime `.tracked()` API, registry, and panel UI are stubs that compile but do not yet wire end-to-end.
