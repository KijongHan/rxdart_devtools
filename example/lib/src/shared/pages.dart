import 'package:flutter/material.dart';

import 'types.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({required this.example, super.key});

  final Example example;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(example.title)),
      body: example.builder(context),
    );
  }
}
