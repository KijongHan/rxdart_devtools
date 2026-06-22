import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:vm_service/vm_service.dart';

class ServiceClient {
  VmService? get _service => serviceManager.service;

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
    final entries = (json[StreamsConstants.jsonEntries] as List?) ?? const [];
    return entries
        .cast<Map<String, Object?>>()
        .map(StreamEntryDto.fromJson)
        .toList();
  }

  Future<List<EventLogDto>> listEventLogs() async {
    final service = _service;
    if (service == null) return const [];
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (isolate == null) return const [];
    final response = await service.callServiceExtension(
      EventsConstants.listEventLogs,
      isolateId: isolate.id,
    );

    final json = response.json;
    if (json == null) return const [];
    return ListEventLogsResponseDto.fromJson(json).eventLogs;
  }

  Future<List<EventLogDto>> listStreamEventLogs(String streamId) async {
    final service = _service;
    if (service == null) return const [];
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (isolate == null) return const [];
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
