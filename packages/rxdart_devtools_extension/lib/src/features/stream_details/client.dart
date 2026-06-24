import 'dart:async';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:vm_service/vm_service.dart';

class StreamDetailsClient {
  StreamDetailsClient() {
    _init();
  }

  final _registered = PublishSubject<StreamEventDto>();
  final _updated = PublishSubject<StreamUpdatedEventDto>();
  final _errored = PublishSubject<StreamUpdatedEventDto>();
  final _closed = PublishSubject<StreamEventDto>();

  Stream<StreamEventDto> get onRegistered => _registered.stream;
  Stream<StreamUpdatedEventDto> get onUpdated => _updated.stream;
  Stream<StreamUpdatedEventDto> get onErrored => _errored.stream;
  Stream<StreamEventDto> get onClosed => _closed.stream;

  late final StreamSubscription<Event>? _sub;

  final _vmServiceProvider = getIt.get<VmServiceProvider>();

  Future<void> _init() async {
    final service = _vmServiceProvider.service;
    if (service == null) {
      _sub = null;
      return;
    }
    try {
      await service.streamListen(EventStreams.kExtension);
    } on RPCError catch (e) {
      if (e.code != 103) rethrow; // 103 = kStreamAlreadySubscribed
    }
    _sub = service.onExtensionEvent.listen(_onExtensionEvent);
  }

  void _onExtensionEvent(Event event) {
    final kind = event.extensionKind;
    final data = event.extensionData?.data;
    if (kind == null || data == null) return;
    final json = Map<String, dynamic>.from(data);
    switch (kind) {
      case StreamsConstants.streamRegistered:
        _registered.add(StreamEventDto.fromJson(json));
      case StreamsConstants.streamUpdated:
        _updated.add(StreamUpdatedEventDto.fromJson(json));
      case StreamsConstants.streamErrored:
        _errored.add(StreamUpdatedEventDto.fromJson(json));
      case StreamsConstants.streamClosed:
        _closed.add(StreamEventDto.fromJson(json));
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _registered.close();
    await _updated.close();
    await _errored.close();
    await _closed.close();
  }

  Future<List<EventLogDto>> listStreamEventLogs(String streamId) async {
    final service = _vmServiceProvider.service;
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (service == null || isolate == null) return const [];
    final request = ListStreamEventLogsRequestDto(streamId: streamId);
    final response = await service.callServiceExtension(
      EventsConstants.listStreamEventLogs,
      isolateId: isolate.id,
      args: request.toJson(),
    );

    final json = response.json;
    if (json == null) return const [];
    return ListEventLogsResponseDto.fromJson(json).eventLogs;
  }
}
