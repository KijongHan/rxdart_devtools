import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/client.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class EventsRepository {
  final BehaviorSubject<List<EventLogDto>> _eventLogs =
      BehaviorSubject<List<EventLogDto>>();

  late final StreamSubscription<EventLogAddedEventDto>
      _onEventAddedSubscription;
  late final StreamSubscription<ConnectedState> _clientConnectedSubscription;
  Stream<List<EventLogDto>> get eventLogs => _eventLogs.stream;

  final EventsClient _eventsClient = getIt.get<EventsClient>();
  final _vmServiceProvider = getIt.get<VmServiceProvider>();

  EventsRepository() {
    _onEventAddedSubscription =
        _eventsClient.onEventAdded.listen((_) => refresh());
    _clientConnectedSubscription =
        _vmServiceProvider.connectedState.listen((state) {
      if (state.connected) {
        refresh();
      }
    });
  }

  void dispose() {
    _onEventAddedSubscription.cancel();
    _clientConnectedSubscription.cancel();
  }

  void refresh() {
    _eventsClient.listEventLogs().then((eventLogs) {
      _eventLogs.add(eventLogs);
    });
  }

  void sort(
      {required SortField sortField, required SortDirection sortDirection,}) {
    _eventsClient
        .listEventLogs(sortField: sortField, sortDirection: sortDirection)
        .then((eventLogs) {
      _eventLogs.add(eventLogs);
    });
  }
}
