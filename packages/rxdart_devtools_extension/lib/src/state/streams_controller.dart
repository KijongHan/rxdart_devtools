import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart_devtools/wire.dart';

import '../service_client.dart';

class StreamsController extends ChangeNotifier {
  StreamsController({
    ServiceClient? client,
    Duration pollInterval = const Duration(seconds: 1),
  })  : _client = client ?? ServiceClient(),
        _pollInterval = pollInterval;

  final ServiceClient _client;
  final Duration _pollInterval;

  Timer? _timer;
  List<TrackedSnapshot> _streams = const [];

  List<TrackedSnapshot> get streams => _streams;

  void start() {
    _timer ??= Timer.periodic(_pollInterval, (_) => _refresh());
    _refresh();
  }

  Future<void> clearClosed() async {
    await _client.clearClosed();
    await _refresh();
  }

  Future<void> _refresh() async {
    final next = await _client.listTracked();
    _streams = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
