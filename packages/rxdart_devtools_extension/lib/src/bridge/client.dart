import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart_devtools/rxdart_devtools_dto.dart';
import 'package:vm_service/vm_service.dart';

class ServiceClient {
  VmService? get _service => serviceManager.service;

  Future<List<StreamEntryDto>> listStreamEntries() async {
    final service = _service;
    if (service == null) return const [];
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (isolate == null) return const [];
    final response = await service.callServiceExtension(
      Constants.listStreamEntries,
      isolateId: isolate.id,
    );

    final json = response.json;
    if (json == null) return const [];
    final entries = (json['entries'] as List?) ?? const [];
    return entries
        .cast<Map<String, Object?>>()
        .map(StreamEntryDto.fromJson)
        .toList();
  }

  Future<void> clearClosed() async {
    final service = _service;
    if (service == null) return;
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (isolate == null) return;
    await service.callServiceExtension(
      Constants.clearClosed,
      isolateId: isolate.id,
    );
  }
}
