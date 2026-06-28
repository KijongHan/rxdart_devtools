import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

class ErrorStreamExamplePage extends StatefulWidget {
  const ErrorStreamExamplePage({super.key});

  @override
  State<ErrorStreamExamplePage> createState() => _ErrorStreamExamplePageState();
}

class _ErrorStreamExamplePageState extends State<ErrorStreamExamplePage> {
  late final PublishSubject<int> _source;
  late final Stream<int> _doubled;

  int _counter = 0;

  @override
  void initState() {
    super.initState();

    _source = PublishSubject<int>().track('errors.source').asSubject();

    _doubled = _source
        .map((value) {
          if (value < 0) {
            throw StateError('negative values are not allowed: $value');
          }
          return value * 2;
        })
        .track('errors.doubled')
        .asStream();
  }

  @override
  void dispose() {
    _source.close();
    super.dispose();
  }

  void _emitValue() {
    _counter++;
    _source.add(_counter);
  }

  void _emitNegative() {
    _source.add(-1);
  }

  void _emitDirectError() {
    _source.addError(
      Exception('manually injected error at ${DateTime.now().toIso8601String()}'),
    );
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
                  'PublishSubject<int> with errors',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tracked as `errors.source` and a derived `errors.doubled`. '
                  'Emit a value to see it doubled; emit -1 to throw inside the '
                  '.map operator; or call addError() directly on the source. '
                  'Either way the rxdart DevTools panel logs an error event for '
                  'the affected stream.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                _StreamRow(
                  label: 'source',
                  stream: _source,
                ),
                const Divider(),
                _StreamRow(
                  label: 'doubled',
                  stream: _doubled,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: _emitValue,
                      icon: const Icon(Icons.add),
                      label: const Text('emit value'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _emitNegative,
                      icon: const Icon(Icons.bolt),
                      label: const Text('emit -1 (throws in map)'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _emitDirectError,
                      icon: const Icon(Icons.error_outline),
                      label: const Text('addError()'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StreamRow extends StatelessWidget {
  const _StreamRow({required this.label, required this.stream});

  final String label;
  final Stream<int> stream;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: theme.textTheme.titleMedium),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StreamBuilder<int>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'error: ${snapshot.error}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Text('waiting…');
                }
                return Text('value: ${snapshot.data}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
