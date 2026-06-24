import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/app.dart';

void main() {
  runApp(const RxDartDevToolsExtension());
}

class RxDartDevToolsExtension extends StatefulWidget {
  const RxDartDevToolsExtension();

  @override
  State<RxDartDevToolsExtension> createState() =>
      RxDartDevToolsExtensionState();
}

class RxDartDevToolsExtensionState extends State<RxDartDevToolsExtension> {
  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(
      child: App(),
    );
  }
}
