import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

class CombineLatestExamplePage extends StatefulWidget {
  const CombineLatestExamplePage({super.key});

  @override
  State<CombineLatestExamplePage> createState() =>
      _CombineLatestExamplePageState();
}

class _CombineLatestExamplePageState extends State<CombineLatestExamplePage> {
  late final BehaviorSubject<int> _a;
  late final BehaviorSubject<int> _b;
  late final Stream<int> _sum;

  @override
  void initState() {
    super.initState();

    _a = BehaviorSubject<int>.seeded(0)
        .track('combineLatest.a')
        .enableInjection(parse: int.tryParse)
        .asSubject();

    _b = BehaviorSubject<int>.seeded(0)
        .track('combineLatest.b')
        .enableInjection(parse: int.tryParse)
        .asSubject();

    _sum = Rx.combineLatest2<int, int, int>(
      _a,
      _b,
      (a, b) => a + b,
    ).shareValue().track('combineLatest.sum').asStream();
  }

  @override
  void dispose() {
    _a.close();
    _b.close();
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
                  'Rx.combineLatest2',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Two injectable BehaviorSubjects (combineLatest.a, .b) feed '
                  'a derived read-only stream (combineLatest.sum). Inject '
                  'values into either input from the panel; the sum updates '
                  'live. shareValue() makes the derived stream a broadcast '
                  'so both the panel and this UI can subscribe.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                _SubjectRow(
                  label: 'a',
                  subject: _a,
                ),
                const Divider(),
                _SubjectRow(
                  label: 'b',
                  subject: _b,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: StreamBuilder<int>(
                    stream: _sum,
                    builder: (context, snapshot) => Text(
                      'a + b = ${snapshot.data ?? '…'}',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.label, required this.subject});

  final String label;
  final BehaviorSubject<int> subject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StreamBuilder<int>(
              stream: subject,
              initialData: subject.value,
              builder: (context, snapshot) =>
                  Text('value: ${snapshot.data ?? 0}'),
            ),
          ),
          IconButton(
            tooltip: 'decrement',
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => subject.add(subject.value - 1),
          ),
          IconButton(
            tooltip: 'increment',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => subject.add(subject.value + 1),
          ),
        ],
      ),
    );
  }
}
