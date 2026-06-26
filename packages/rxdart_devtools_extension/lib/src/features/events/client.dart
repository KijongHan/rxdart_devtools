import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:vm_service/vm_service.dart';

class EventsClient {
  EventsClient() {
    _connectionSubscription =
        _vmServiceProvider.connectedState.listen(_onConnectedStateChanged);
  }

  final _eventAdded = PublishSubject<EventLogAddedEventDto>();
  Stream<EventLogAddedEventDto> get onEventAdded => _eventAdded.stream;

  late final StreamSubscription<Event>? _sub;
  late final StreamSubscription<void> _connectionSubscription;
  final _vmServiceProvider = getIt.get<VmServiceProvider>();

  void _onConnectedStateChanged(ConnectedState state) async {
    if (!state.connected) return;

    await _vmServiceProvider.streamListen(EventStreams.kExtension);
    _sub =
        _vmServiceProvider.service?.onExtensionEvent.listen(_onExtensionEvent);
  }

  void _onExtensionEvent(Event event) {
    final kind = event.extensionKind;
    final data = event.extensionData?.data;
    if (kind == null || data == null) return;
    final json = Map<String, dynamic>.from(data);
    switch (kind) {
      case EventsConstants.eventAdded:
        _eventAdded.add(EventLogAddedEventDto.fromJson(json));
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _eventAdded.close();
    await _connectionSubscription.cancel();
  }

  Future<List<EventLogDto>> listEventLogs(
      {String? streamId,
      SortField? sortField,
      SortDirection? sortDirection}) async {
    final service = _vmServiceProvider.service;
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (service == null || isolate == null) return const [];
    final response = await service.callServiceExtension(
      EventsConstants.listEventLogs,
      isolateId: isolate.id,
      args: {
        ...ListEventLogsRequestDto(
          streamId: streamId,
        ).toJson(),
        ...SortRequestDto(
          sortField: sortField,
          sortDirection: sortDirection,
        ).toJson(),
      },
    );

    final json = response.json;
    if (json == null) return const [];
    return ListEventLogsResponseDto.fromJson(json).eventLogs;
  }
}
