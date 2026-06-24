import 'dart:async';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:vm_service/vm_service.dart';

class StreamsClient {
  StreamsClient() {
    _init();
  }

  VmService? get _service => serviceManager.service;

  final _registered = PublishSubject<StreamEventDto>();
  final _updated = PublishSubject<StreamUpdatedEventDto>();
  final _errored = PublishSubject<StreamUpdatedEventDto>();
  final _closed = PublishSubject<StreamEventDto>();

  Stream<StreamEventDto> get onRegistered => _registered.stream;
  Stream<StreamUpdatedEventDto> get onUpdated => _updated.stream;
  Stream<StreamUpdatedEventDto> get onErrored => _errored.stream;
  Stream<StreamEventDto> get onClosed => _closed.stream;

  StreamSubscription<Event>? _sub;

  Future<void> _init() async {
    final service = _service;
    if (service == null) return;
    try {
      await service.streamListen(EventStreams.kExtension);
    } on RPCError catch (e) {
      if (e.code != 103) rethrow; // 103 = kStreamAlreadySubscribed
    }
    _sub = service.onExtensionEvent.listen(_dispatch);
  }

  void _dispatch(Event event) {
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

  Future<List<StreamEntryDto>> listStreamEntries() async {
    final service = _service;
    if (service == null) return const [];
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (isolate == null) return const [];
    final response = await service.callServiceExtension(
      StreamsConstants.listStreamEntries,
      isolateId: isolate.id,
    );

    final json = response.json;
    if (json == null) return const [];
    return ListStreamEntriesResponseDto.fromJson(json).entries;
  }

  Future<void> clearClosed() async {
    final service = _service;
    if (service == null) return;
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (isolate == null) return;
    await service.callServiceExtension(
      StreamsConstants.clearClosed,
      isolateId: isolate.id,
    );
  }
}
