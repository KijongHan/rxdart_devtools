import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/sdk.dart';

class CounterExamplePage extends StatefulWidget {
  const CounterExamplePage({super.key});

  @override
  State<CounterExamplePage> createState() => _CounterExamplePageState();
}

class _CounterExamplePageState extends State<CounterExamplePage> {
  late final BehaviorSubject<int> _counter;
  Timer? _timer;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _counter = BehaviorSubject<int>.seeded(0)
        .track('counter.ticker')
        .asSubject();
    _startTicker();
  }

  void _startTicker() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _counter.add(_counter.value + 1);
    });
  }

  void _toggle() {
    if (_isRunning) {
      _timer?.cancel();
      _timer = null;
    } else {
      _startTicker();
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _reset() {
    _counter.add(0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _counter.close();
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
                  'BehaviorSubject<int> — auto-incrementing every 1s',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tracked as counter.ticker. A Timer.periodic pushes the '
                  'next value once per second. Pause to halt emissions; '
                  'reset to push 0 immediately.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                StreamBuilder<int>(
                  stream: _counter,
                  initialData: _counter.value,
                  builder: (context, snapshot) => Text(
                    'count: ${snapshot.data}',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: _toggle,
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(_isRunning ? 'Pause' : 'Resume'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
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
