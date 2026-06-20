import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'streams.dart';

final class Lifecycle {
  Lifecycle() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addObserver(_HotReloadObserver());
  }
}

class _HotReloadObserver with WidgetsBindingObserver {
  final streamsService = GetIt.I.get<StreamsService>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  // Hot reload — Flutter calls reassemble on every widget. The widgets binding
  // fires didReassemble before propagation. We hook there to evict closed entries.
  void didReassemble() {
    streamsService.clearClosed();
  }
}
