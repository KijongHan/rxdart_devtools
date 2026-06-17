import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/rxdart_devtools.dart';

void main() {
  RxDartDevtools.init(historySize: 50);
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  late final BehaviorSubject<int> _counter;
  late final PublishSubject<String> _query;
  late final BehaviorSubject<DateTime> _clock;

  Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    _counter = BehaviorSubject<int>.seeded(0).tracked('counter');
    _query = PublishSubject<String>().tracked('search.query', historySize: 200);
    _clock = BehaviorSubject<DateTime>.seeded(DateTime.now()).tracked('clock');

    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _clock.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _counter.close();
    _query.close();
    _clock.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rxdart_devtools example',
      home: Scaffold(
        appBar: AppBar(title: const Text('rxdart_devtools example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Open DevTools → RxDart tab to inspect tracked streams.'),
              const SizedBox(height: 24),
              Text('counter: ${_counter.value}'),
              const SizedBox(height: 8),
              Text('clock: ${_clock.value}'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _counter.add(_counter.value + 1),
                child: const Text('counter++'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    _query.add('q-${DateTime.now().millisecondsSinceEpoch}'),
                child: const Text('emit search.query'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
