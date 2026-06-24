import 'package:devtools_app_shared/service.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:vm_service/vm_service.dart';
import 'package:rxdart/rxdart.dart';

final getIt = GetIt.instance;

final class VmServiceProvider {
  final _connectedState = BehaviorSubject<ConnectedState>();
  Stream<ConnectedState> get connectedState => _connectedState.stream;

  VmService? get service => serviceManager.service;

  ServiceManager get manager => serviceManager;

  VmServiceProvider() {
    serviceManager.connectedState.addListener(_onConnectedStateChanged);
  }

  void _onConnectedStateChanged() {
    _connectedState.add(serviceManager.connectedState.value);
  }

  Future<void> streamListen(String streamId) async {
    final service = serviceManager.service;
    if (service == null) return;
    try {
      await service.streamListen(streamId);
    } on RPCError catch (e) {
      if (e.code != RPCErrorKind.kStreamAlreadySubscribed.code) rethrow;
    }
  }

  Future<void> dispose() async {
    await _connectedState.close();
    serviceManager.connectedState.removeListener(_onConnectedStateChanged);
  }
}
