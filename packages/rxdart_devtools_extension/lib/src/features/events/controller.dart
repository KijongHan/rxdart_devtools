import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart_devtools/dto.dart';

import 'client.dart';

class EventsController extends ChangeNotifier {
  EventsController({
    EventsClient? client,
    Duration pollInterval = const Duration(seconds: 1),
  })  : _client = client ?? EventsClient(),
        _pollInterval = pollInterval;

  final EventsClient _client;
  final Duration _pollInterval;

  Timer? _timer;
  List<EventLogDto> _eventLogs = const [];

  List<EventLogDto> get eventLogs => _eventLogs;

  void start() {
    _timer ??= Timer.periodic(_pollInterval, (_) => _refresh());
    _refresh();
  }

  Future<void> _refresh() async {
    final next = await _client.listEventLogs();
    _eventLogs = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
