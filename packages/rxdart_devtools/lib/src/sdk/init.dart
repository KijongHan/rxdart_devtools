import 'package:flutter/foundation.dart';
import 'package:rxdart_devtools/src/features/config/types.dart';
import 'package:rxdart_devtools/src/features/registry/providers.dart';
import 'package:rxdart_devtools/src/features/config/providers.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/features/streams/service.dart';

import '../features/streams/backend.dart';
import '../features/events/backend.dart';

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
        config: SdkConfig(
          historySize: historySize,
          closedEntryCap: closedEntryCap,
          captureStackTraces: captureStackTraces,
          enabled: enabled,
        ),
      ),
    );
    getIt.registerSingleton(DateTimeProvider());
    getIt.registerSingleton(UuidProvider());
    getIt.registerSingleton(StreamIdentifierProvider());

    getIt.registerSingleton(StreamsService());
    getIt.registerSingleton(EventsService());
    getIt.registerSingleton(RegistryService());

    getIt.registerSingleton(StreamsBackend());
    getIt.registerSingleton(EventsBackend());
    _initialized = true;
  }
}
