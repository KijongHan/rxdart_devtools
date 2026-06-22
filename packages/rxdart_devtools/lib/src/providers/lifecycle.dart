import 'package:flutter/widgets.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

import '../features/streams/service.dart';

final class Lifecycle {
  Lifecycle() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(_HotReloadObserver());
  }
}

class _HotReloadObserver with WidgetsBindingObserver {
  final streamsService = getIt.get<StreamsService>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  // Hot reload — Flutter calls reassemble on every widget. The widgets binding
  // fires didReassemble before propagation. We hook there to evict closed entries.
  void didReassemble() {
    streamsService.clearClosed();
  }
}
