import 'package:flutter/widgets.dart';

import 'registry.dart';

abstract final class Lifecycle {
  static bool _installed = false;

  static void install() {
    if (_installed) return;
    _installed = true;
    WidgetsFlutterBinding.ensureInitialized();
    final binding = WidgetsBinding.instance;
    binding.addObserver(_HotReloadObserver());
  }
}

class _HotReloadObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  // Hot reload — Flutter calls reassemble on every widget. The widgets binding
  // fires didReassemble before propagation. We hook there to evict closed entries.
  void didReassemble() {
    Registry.instance.clearClosed();
  }
}
