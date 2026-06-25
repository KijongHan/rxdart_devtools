import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

final class RegistryClient {
  final _vmServiceProvider = getIt.get<VmServiceProvider>();

  void inject(String streamId, String value) async {
    if (_vmServiceProvider.service == null ||
        _vmServiceProvider.manager.isolateManager.selectedIsolate.value ==
            null) {
      return;
    }
    final response = await _vmServiceProvider.service!.callServiceExtension(
      RegistryConstants.inject,
      isolateId:
          _vmServiceProvider.manager.isolateManager.selectedIsolate.value!.id,
      args: InjectRequestDto(identifier: streamId, raw: value).toJson(),
    );
  }

  void injectError(String streamId, String message) async {
    if (_vmServiceProvider.service == null ||
        _vmServiceProvider.manager.isolateManager.selectedIsolate.value ==
            null) {
      return;
    }
    final response = await _vmServiceProvider.service!.callServiceExtension(
      RegistryConstants.injectError,
      isolateId:
          _vmServiceProvider.manager.isolateManager.selectedIsolate.value!.id,
      args: InjectErrorRequestDto(identifier: streamId, message: message)
          .toJson(),
    );
  }
}
