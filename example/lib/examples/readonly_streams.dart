import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart_devtools/sdk.dart';

class ReadonlyStreamsExample extends StatefulWidget {
  const ReadonlyStreamsExample({super.key});

  @override
  State<ReadonlyStreamsExample> createState() => _ReadonlyStreamsExampleState();
}

class _ReadonlyStreamsExampleState extends State<ReadonlyStreamsExample> {
  late final Stream<DateTime> _clock;
  late final Stream<int> _counter;
  late final StreamController<int> _counterController;

  Timer? _counterTimer;
  int _counterValue = 0;

  @override
  void initState() {
    super.initState();

    _clock = Stream<DateTime>.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now(),
    ).asBroadcastStream().track('readonly.clock').asStream();

    _counterController = StreamController<int>.broadcast();
    _counter = _counterController.stream.track('readonly.counter').asStream();
    _counterTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _counterValue++;
      _counterController.add(_counterValue);
    });
  }

  @override
  void dispose() {
    _counterTimer?.cancel();
    _counterController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Card<DateTime>(
          title: 'Stream<DateTime>.periodic',
          panelExpectation:
              'Emissions appear in the panel; no inject affordance because '
              'this is a plain Stream, not a Subject.',
          stream: _clock,
          format: (v) => v == null ? 'waiting…' : v.toIso8601String(),
        ),
        const SizedBox(height: 16),
        _Card<int>(
          title: 'Stream<int> from StreamController.broadcast',
          panelExpectation:
              'A service-style stream — internal StreamController emits via '
              'a Timer, only the read side is exposed. Panel observes but '
              'cannot push values.',
          stream: _counter,
          format: (v) => v == null ? 'no value yet' : 'count: $v',
        ),
      ],
    );
  }
}

class _Card<T> extends StatelessWidget {
  const _Card({
    required this.title,
    required this.panelExpectation,
    required this.stream,
    required this.format,
  });

  final String title;
  final String panelExpectation;
  final Stream<T> stream;
  final String Function(T? value) format;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'In the DevTools panel: $panelExpectation',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            StreamBuilder<T>(
              stream: stream,
              builder: (context, snapshot) => Text(
                format(snapshot.data),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
