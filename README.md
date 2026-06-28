# rxdart_devtools

A Dart DevTools extension for inspecting RxDart streams.

<!-- TODO: drop a GIF/screenshot of the panel here. -->
<!-- Suggested: build via `melos run build:panel:simulated`, record a 5-10s capture of streams updating + an injection. -->

- 📦 [Package on pub.dev](https://pub.dev/packages/rxdart_devtools)
- 📖 [Documentation](https://kijonghan.github.io/rxdart_devtools/)
- 🐛 [Issues](https://github.com/KijongHan/rxdart_devtools/issues)

> Looking to *use* the extension? See the [package README](packages/rxdart_devtools/README.md). This file is for working on the codebase.

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

Early release. v0.x — API may change before 1.0. Tracking, panel UI, value injection, and clear-all are wired end-to-end; edge cases are being shaken out. See [CONTRIBUTING.md](CONTRIBUTING.md) for how to develop locally.
