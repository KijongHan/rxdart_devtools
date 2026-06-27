import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

class InjectableSubjectExample extends StatefulWidget {
  const InjectableSubjectExample({super.key});

  @override
  State<InjectableSubjectExample> createState() =>
      _InjectableSubjectExampleState();
}

class _InjectableSubjectExampleState extends State<InjectableSubjectExample> {
  late final BehaviorSubject<int> _count;

  @override
  void initState() {
    super.initState();
    _count = BehaviorSubject<int>.seeded(0)
        .track('injectable.count')
        .enableInjection(parse: (raw) => int.tryParse(raw) ?? 0)
        .asSubject();
  }

  @override
  void dispose() {
    _count.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BehaviorSubject<int> with enableInjection',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tracked as `injectable.count`. In the rxdart DevTools '
                  'panel, type a number into the injection field and submit '
                  '— the stream receives your value as if the app had '
                  'emitted it. The parse callback turns the raw string '
                  'into an int.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                StreamBuilder<int>(
                  stream: _count,
                  initialData: _count.value,
                  builder: (context, snapshot) => Text(
                    'count: ${snapshot.data}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _count.add(_count.value + 1),
                  child: const Text('increment locally'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
