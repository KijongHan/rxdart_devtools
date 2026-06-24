import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/client.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class StreamDetailsViewModel {
  final BehaviorSubject<String?> _selectedStreamId =
      BehaviorSubject<String?>.seeded(null);
  final BehaviorSubject<List<EventLogDto>> _eventLogs =
      BehaviorSubject<List<EventLogDto>>.seeded(const []);

  late final StreamSubscription<String?> _selectionSubscription;
  late final StreamSubscription<StreamEventDto> _onRegisteredSubscription;
  late final StreamSubscription<StreamEventDto> _onClosedSubscription;
  late final StreamSubscription<StreamUpdatedEventDto> _onUpdatedSubscription;
  late final StreamSubscription<StreamUpdatedEventDto> _onErroredSubscription;

  Stream<String?> get selectedStreamId => _selectedStreamId.stream;
  Stream<List<EventLogDto>> get eventLogs => _eventLogs.stream;

  String? get currentSelectedStreamId => _selectedStreamId.valueOrNull;

  final StreamDetailsClient _streamDetailsClient =
      getIt.get<StreamDetailsClient>();

  StreamDetailsViewModel() {
    _selectionSubscription = _selectedStreamId.distinct().listen((id) {
      _eventLogs.add(const []);
      if (id != null) refresh();
    });
    _onRegisteredSubscription = _streamDetailsClient.onRegistered
        .listen((event) => _refreshIfMatches(event.streamId));
    _onClosedSubscription = _streamDetailsClient.onClosed
        .listen((event) => _refreshIfMatches(event.streamId));
    _onUpdatedSubscription = _streamDetailsClient.onUpdated
        .listen((event) => _refreshIfMatches(event.streamId));
    _onErroredSubscription = _streamDetailsClient.onErrored
        .listen((event) => _refreshIfMatches(event.streamId));
  }

  void selectStream(String? streamId) {
    _selectedStreamId.add(streamId);
  }

  void _refreshIfMatches(String streamId) {
    if (_selectedStreamId.valueOrNull == streamId) refresh();
  }

  void refresh() {
    final id = _selectedStreamId.valueOrNull;
    if (id == null) return;
    _streamDetailsClient.listStreamEventLogs(id).then((eventLogs) {
      // Selection changed mid-flight — discard.
      if (_selectedStreamId.valueOrNull != id) return;
      _eventLogs.add(eventLogs);
    });
  }

  void dispose() {
    _selectionSubscription.cancel();
    _onRegisteredSubscription.cancel();
    _onClosedSubscription.cancel();
    _onUpdatedSubscription.cancel();
    _onErroredSubscription.cancel();
    _selectedStreamId.close();
    _eventLogs.close();
  }
}
