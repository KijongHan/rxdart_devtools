import 'package:flutter/material.dart';
import 'package:rxdart_devtools/sdk.dart';

import 'src/app.dart';

void main() {
  RxDartDevtools.init();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rxdart_devtools example',
      theme: ThemeData(useMaterial3: true),
      home: const ExamplesApp(),
    );
  }
}
