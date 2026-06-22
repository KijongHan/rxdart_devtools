import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:vm_service/vm_service.dart';

class EventsClient {
  VmService? get _service => serviceManager.service;

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
}
