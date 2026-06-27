import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

class PrimitiveSubjectsExample extends StatefulWidget {
  const PrimitiveSubjectsExample({super.key});

  @override
  State<PrimitiveSubjectsExample> createState() =>
      _PrimitiveSubjectsExampleState();
}

class _PrimitiveSubjectsExampleState extends State<PrimitiveSubjectsExample> {
  late final BehaviorSubject<int> _behavior;
  late final PublishSubject<String> _publish;
  late final ReplaySubject<bool> _replay;

  int _publishCounter = 0;
  bool _replayToggle = false;

  @override
  void initState() {
    super.initState();
    _behavior = BehaviorSubject<int>.seeded(0)
        .track('primitives.behavior')
        .asSubject();
    _publish =
        PublishSubject<String>().track('primitives.publish').asSubject();
    _replay = ReplaySubject<bool>(maxSize: 5)
        .track('primitives.replay')
        .asSubject();
  }

  @override
  void dispose() {
    _behavior.close();
    _publish.close();
    _replay.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SubjectCard<int>(
          title: 'BehaviorSubject<int>',
          subtitle:
              'Replays the latest emission to new listeners. Starts seeded at 0.',
          stream: _behavior,
          initialData: _behavior.value,
          format: (v) => 'latest: $v',
          actionLabel: 'increment',
          onAction: () => _behavior.add(_behavior.value + 1),
        ),
        const SizedBox(height: 16),
        _SubjectCard<String>(
          title: 'PublishSubject<String>',
          subtitle:
              'Only delivers events emitted after a listener subscribes. '
              'Late subscribers see nothing until the next emission.',
          stream: _publish,
          format: (v) => v == null ? 'waiting…' : 'last: $v',
          actionLabel: 'emit message',
          onAction: () {
            _publishCounter++;
            _publish.add('msg-$_publishCounter');
          },
        ),
        const SizedBox(height: 16),
        _SubjectCard<bool>(
          title: 'ReplaySubject<bool>',
          subtitle:
              'Replays the last N emissions to new listeners (maxSize: 5).',
          stream: _replay,
          format: (v) => v == null ? 'no emissions yet' : 'last: $v',
          actionLabel: 'toggle',
          onAction: () {
            _replayToggle = !_replayToggle;
            _replay.add(_replayToggle);
          },
        ),
      ],
    );
  }
}

class _SubjectCard<T> extends StatelessWidget {
  const _SubjectCard({
    required this.title,
    required this.subtitle,
    required this.stream,
    required this.format,
    required this.actionLabel,
    required this.onAction,
    this.initialData,
  });

  final String title;
  final String subtitle;
  final Stream<T> stream;
  final String Function(T? value) format;
  final String actionLabel;
  final VoidCallback onAction;
  final T? initialData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            StreamBuilder<T>(
              stream: stream,
              initialData: initialData,
              builder: (context, snapshot) => Text(
                format(snapshot.data),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
