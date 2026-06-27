import 'package:flutter/material.dart';

import '../examples/all.dart';
import '../examples/example.dart';

class ExamplesListPage extends StatelessWidget {
  const ExamplesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('rxdart_devtools examples')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: kExamples.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final example = kExamples[index];
          return ListTile(
            title: Text(example.title),
            subtitle: Text(example.description),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ExamplePage(example: example),
                settings: RouteSettings(name: '/examples/${example.id}'),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
