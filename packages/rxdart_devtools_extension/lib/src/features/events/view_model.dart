import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/client.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class EventsViewModel {
  final BehaviorSubject<List<EventLogDto>> _eventLogs =
      BehaviorSubject<List<EventLogDto>>();

  late final StreamSubscription<StreamEventDto> _onRegisteredSubscription;
  late final StreamSubscription<StreamEventDto> _onClosedSubscription;
  late final StreamSubscription<StreamUpdatedEventDto> _onUpdatedSubscription;
  late final StreamSubscription<StreamUpdatedEventDto> _onErroredSubscription;
  late final StreamSubscription<ConnectedState> _clientConnectedSubscription;
  Stream<List<EventLogDto>> get eventLogs => _eventLogs.stream;

  final EventsClient _eventsClient = getIt.get<EventsClient>();
  final _vmServiceProvider = getIt.get<VmServiceProvider>();
  EventsViewModel() {
    _onRegisteredSubscription =
        _eventsClient.onRegistered.listen((_) => refresh());
    _onClosedSubscription = _eventsClient.onClosed.listen((_) => refresh());
    _onUpdatedSubscription = _eventsClient.onUpdated.listen((_) => refresh());
    _onErroredSubscription = _eventsClient.onErrored.listen((_) => refresh());
    _clientConnectedSubscription =
        _vmServiceProvider.connectedState.listen((state) {
      if (state.connected) {
        refresh();
      }
    });
  }

  void dispose() {
    _onRegisteredSubscription.cancel();
    _onClosedSubscription.cancel();
    _onUpdatedSubscription.cancel();
    _onErroredSubscription.cancel();
    _clientConnectedSubscription.cancel();
  }

  void refresh() {
    _eventsClient.listEventLogs().then((eventLogs) {
      _eventLogs.add(eventLogs);
    });
  }
}
