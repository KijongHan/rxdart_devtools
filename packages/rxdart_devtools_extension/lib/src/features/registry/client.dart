import 'package:result_dart/result_dart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:vm_service/vm_service.dart' hide Success;

final class RegistryClient {
  final _vmServiceProvider = getIt.get<VmServiceProvider>();

  Future<Result<void>> inject(String streamId, String value) async {
    if (_vmServiceProvider.service == null ||
        _vmServiceProvider.manager.isolateManager.selectedIsolate.value ==
            null) {
      return Failure(Exception('No VM service available'));
    }

    try {
      await _vmServiceProvider.service!.callServiceExtension(
        RegistryConstants.inject,
        isolateId:
            _vmServiceProvider.manager.isolateManager.selectedIsolate.value!.id,
        args: InjectRequestDto(identifier: streamId, raw: value).toJson(),
      );
      return Success.unit();
    } on RPCError catch (e) {
      return Failure(Exception(e.message));
    }
  }

  Future<Result<void>> injectError(String streamId, String message) async {
    if (_vmServiceProvider.service == null ||
        _vmServiceProvider.manager.isolateManager.selectedIsolate.value ==
            null) {
      return Failure(Exception('No VM service available'));
    }
    try {
      await _vmServiceProvider.service!.callServiceExtension(
        RegistryConstants.injectError,
        isolateId:
            _vmServiceProvider.manager.isolateManager.selectedIsolate.value!.id,
        args: InjectErrorRequestDto(identifier: streamId, message: message)
            .toJson(),
      );
      return Success.unit();
    } on RPCError catch (e) {
      return Failure(Exception(e.message));
    }
  }
}
