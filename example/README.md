# rxdart_devtools example

A minimal Flutter app that exercises the `.track()` API.

## First-time setup

This package contains only `lib/` and `pubspec.yaml`. To add iOS/Android/web platform scaffolding, run:

```bash
cd example
flutter create . --platforms=ios,android,macos,windows,linux,web --org dev.rxdart
```

Then:

```bash
flutter run
```

Open DevTools (it auto-opens with `flutter run`), connect to the app, and select the **RxDart** tab.
