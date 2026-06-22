import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart_devtools/dto.dart';

import 'client.dart';

class StreamsController extends ChangeNotifier {
  StreamsController({
    StreamsClient? client,
    Duration pollInterval = const Duration(seconds: 1),
  })  : _client = client ?? StreamsClient(),
        _pollInterval = pollInterval;

  final StreamsClient _client;
  final Duration _pollInterval;

  Timer? _timer;
  List<StreamEntryDto> _streams = const [];

  List<StreamEntryDto> get streams => _streams;

  void start() {
    _timer ??= Timer.periodic(_pollInterval, (_) => _refresh());
    _refresh();
  }

  Future<void> clearClosed() async {
    await _client.clearClosed();
    await _refresh();
  }

  Future<void> _refresh() async {
    final next = await _client.listStreamEntries();
    _streams = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
