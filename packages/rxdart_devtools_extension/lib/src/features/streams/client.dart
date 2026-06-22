import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:vm_service/vm_service.dart';

class StreamsClient {
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
