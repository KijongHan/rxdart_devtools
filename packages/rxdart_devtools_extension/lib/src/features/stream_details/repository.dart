import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/client.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class StreamDetailsRepository {
  final BehaviorSubject<String?> _selectedStreamId =
      BehaviorSubject<String?>.seeded(null);
  final BehaviorSubject<List<EventLogDto>> _eventLogs =
      BehaviorSubject<List<EventLogDto>>.seeded(const []);

  late final StreamSubscription<String?> _selectionSubscription;
  late final StreamSubscription<EventLogAddedEventDto>
      _onEventAddedSubscription;

  Stream<String?> get selectedStreamId => _selectedStreamId.stream;
  Stream<List<EventLogDto>> get eventLogs => _eventLogs.stream;

  String? get currentSelectedStreamId => _selectedStreamId.valueOrNull;

  final EventsClient _eventsClient = getIt.get<EventsClient>();

  StreamDetailsRepository() {
    _selectionSubscription = _selectedStreamId.distinct().listen((id) {
      _eventLogs.add(const []);
      if (id != null) refresh();
    });
    _onEventAddedSubscription = _eventsClient.onEventAdded
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
    _eventsClient.listEventLogs(streamId: id).then((eventLogs) {
      // Selection changed mid-flight — discard.
      if (_selectedStreamId.valueOrNull != id) return;
      _eventLogs.add(eventLogs);
    });
  }

  void dispose() {
    _selectionSubscription.cancel();
    _onEventAddedSubscription.cancel();
    _selectedStreamId.close();
    _eventLogs.close();
  }
}
