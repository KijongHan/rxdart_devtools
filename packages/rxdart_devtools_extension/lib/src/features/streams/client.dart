import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:vm_service/vm_service.dart';

class StreamsClient {
  StreamsClient() {
    _connectionSubscription =
        _vmServiceProvider.connectedState.listen(_onConnectedStateChanged);
  }

  final _registered = PublishSubject<StreamEventDto>();
  final _updated = PublishSubject<StreamUpdatedEventDto>();
  final _errored = PublishSubject<StreamUpdatedEventDto>();
  final _closed = PublishSubject<StreamEventDto>();
  Stream<StreamEventDto> get onRegistered => _registered.stream;
  Stream<StreamUpdatedEventDto> get onUpdated => _updated.stream;
  Stream<StreamUpdatedEventDto> get onErrored => _errored.stream;
  Stream<StreamEventDto> get onClosed => _closed.stream;

  late final StreamSubscription<Event>? _pushSubscription;
  late final StreamSubscription<void> _connectionSubscription;

  final _vmServiceProvider = getIt.get<VmServiceProvider>();

  void _onConnectedStateChanged(ConnectedState state) async {
    if (!state.connected) return;

    await _vmServiceProvider.service
        ?.streamListen(StreamsConstants.streamRegistered);
    _pushSubscription =
        _vmServiceProvider.service?.onExtensionEvent.listen(_onExtensionEvent);
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
    await _connectionSubscription.cancel();
    await _pushSubscription?.cancel();
    await _registered.close();
    await _updated.close();
    await _errored.close();
    await _closed.close();
  }

  Future<List<StreamEntryDto>> listStreamEntries() async {
    if (_vmServiceProvider.service == null ||
        serviceManager.isolateManager.selectedIsolate.value == null) {
      return const [];
    }
    final response = await _vmServiceProvider.service!.callServiceExtension(
      StreamsConstants.listStreamEntries,
      isolateId: serviceManager.isolateManager.selectedIsolate.value!.id,
    );

    final json = response.json;
    if (json == null) return const [];
    return ListStreamEntriesResponseDto.fromJson(json).entries;
  }

  Future<void> clearClosed() async {
    if (_vmServiceProvider.service == null ||
        serviceManager.isolateManager.selectedIsolate.value == null) {
      return;
    }
    await _vmServiceProvider.service!.callServiceExtension(
      StreamsConstants.clearClosed,
      isolateId: serviceManager.isolateManager.selectedIsolate.value!.id,
    );
  }
}
