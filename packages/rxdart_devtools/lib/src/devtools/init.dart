import 'package:flutter/foundation.dart';
import 'package:rxdart_devtools/src/providers/config.dart';
import 'package:rxdart_devtools/src/providers/get_it.dart';
import 'package:rxdart_devtools/src/services/events.dart';
import 'package:rxdart_devtools/src/services/registry.dart';
import 'package:rxdart_devtools/src/services/streams.dart';

import '../services/lifecycle.dart';
import '../bridge/backend.dart';

class RxDartDevtoolsConfig {
  const RxDartDevtoolsConfig({
    this.historySize = 20,
    this.closedEntryCap = 256,
    this.captureStackTraces = true,
    this.enabled = true,
  });

  final int historySize;
  final int closedEntryCap;
  final bool captureStackTraces;
  final bool enabled;
}

abstract final class RxDartDevtools {
  static bool _initialized = false;

  static void init({
    int historySize = 20,
    int closedEntryCap = 256,
    bool captureStackTraces = true,
    bool enabled = true,
  }) {
    if (kReleaseMode || _initialized) return;

    getIt.registerSingleton(
      ConfigProvider(
        config: RxDartDevtoolsConfig(
          historySize: historySize,
          closedEntryCap: closedEntryCap,
          captureStackTraces: captureStackTraces,
          enabled: enabled,
        ),
      ),
    );
    getIt.registerSingleton(StreamsService());
    getIt.registerSingleton(EventsService());
    getIt.registerSingleton(RegistryService());

    getIt.registerSingleton(ServiceBackend());
    getIt.registerSingleton(Lifecycle());
    _initialized = true;
  }
}
