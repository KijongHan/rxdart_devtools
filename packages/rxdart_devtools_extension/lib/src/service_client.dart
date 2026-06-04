import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:rxdart_devtools/wire.dart';
import 'package:vm_service/vm_service.dart';

class ServiceClient {
  ServiceClient() : _service = serviceManager.service;

  final VmService? _service;

  Future<List<TrackedSnapshot>> listTracked() async {
    final service = _service;
    if (service == null) return const [];
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (isolate == null) return const [];

    final response = await service.callServiceExtension(
      'ext.rxdart.list',
      isolateId: isolate.id,
    );
    final json = response.json;
    if (json == null) return const [];
    final entries = (json['entries'] as List?) ?? const [];
    return entries
        .cast<Map<String, Object?>>()
        .map(TrackedSnapshot.fromJson)
        .toList();
  }

  Future<void> clearClosed() async {
    final service = _service;
    if (service == null) return;
    final isolate = serviceManager.isolateManager.selectedIsolate.value;
    if (isolate == null) return;
    await service.callServiceExtension(
      'ext.rxdart.clearClosed',
      isolateId: isolate.id,
    );
  }
}
