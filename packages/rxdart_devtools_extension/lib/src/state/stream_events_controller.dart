import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart_devtools/rxdart_devtools_dto.dart';

import '../bridge/client.dart';

class StreamEventsController extends ChangeNotifier {
  StreamEventsController({
    ServiceClient? client,
    Duration pollInterval = const Duration(seconds: 1),
  })  : _client = client ?? ServiceClient(),
        _pollInterval = pollInterval;

  final ServiceClient _client;
  final Duration _pollInterval;

  Timer? _timer;
  String? _selectedStreamId;
  List<EventLogDto> _eventLogs = const [];

  String? get selectedStreamId => _selectedStreamId;
  List<EventLogDto> get eventLogs => _eventLogs;

  void start() {
    _timer ??= Timer.periodic(_pollInterval, (_) => _refresh());
  }

  void selectStream(String? streamId) {
    if (_selectedStreamId == streamId) return;
    _selectedStreamId = streamId;
    _eventLogs = const [];
    notifyListeners();
    if (streamId != null) {
      _refresh();
    }
  }

  Future<void> _refresh() async {
    final id = _selectedStreamId;
    if (id == null) return;
    final next = await _client.listStreamEventLogs(id);
    // Selection changed mid-flight — discard.
    if (_selectedStreamId != id) return;
    _eventLogs = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
