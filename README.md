# rxdart_devtools

A Dart & Flutter DevTools extension for inspecting RxDart Subjects and Dart Streams.

![rxdart_devtools panel in action](https://raw.githubusercontent.com/KijongHan/rxdart_devtools/main/assets/panel-demo-subjects.gif)

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

## Contributing

Appreciate any contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for prerequisites, local dev setup, and the melos scripts used during development.

## License

[MIT](LICENSE). This is a community project, not affiliated with or endorsed by the rxdart maintainers or ReactiveX.

## Status

Currently early release and actively being improved on
