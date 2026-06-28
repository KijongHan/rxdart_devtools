import 'package:flutter/material.dart';
import 'package:rxdart_devtools_example/src/shared/pages.dart';

import 'routes.dart';

class ExamplesApp extends StatelessWidget {
  const ExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('rxdart_devtools examples')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: examples.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final example = examples[index];
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
