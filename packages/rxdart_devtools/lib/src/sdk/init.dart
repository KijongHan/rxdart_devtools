import 'package:flutter/foundation.dart';
import 'package:rxdart_devtools/src/features/config/types.dart';
import 'package:rxdart_devtools/src/features/registry/providers.dart';
import 'package:rxdart_devtools/src/features/config/providers.dart';
import 'package:rxdart_devtools/src/features/registry/types.dart';
import 'package:rxdart_devtools/src/features/streams/push.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/features/streams/service.dart';

import '../features/streams/backend.dart';
import '../features/events/backend.dart';
import '../features/events/push.dart';
import '../features/registry/backend.dart';

/// Entry point for the `rxdart_devtools` runtime.
///
/// Call [init] once from `main()` before `runApp` to wire up the services that
/// surface tracked streams to the DevTools panel. The call is a no-op in
/// release builds and when invoked more than once, so it is safe to leave in
/// production code.
abstract final class RxDartDevtools {
  static bool _initialized = false;

  /// Initialises the DevTools runtime.
  ///
  /// In release builds and on repeated calls this returns immediately without
  /// registering any services. Pass [streamIdentifierStrategy] to control how
  /// tracked streams are identified across hot reloads — defaults to
  /// [StreamIdentifierStrategy.name], which keys by the name passed to
  /// `.track()`.
  static void init({
    StreamIdentifierStrategy streamIdentifierStrategy =
        StreamIdentifierStrategy.name,
  }) {
    if (kReleaseMode || _initialized) return;

    getIt.registerSingleton(
      ConfigProvider(
        config: SdkConfig(
          streamIdentifierStrategy: streamIdentifierStrategy,
        ),
      ),
    );
    getIt.registerSingleton(DateTimeProvider());
    getIt.registerSingleton(UuidProvider());
    getIt.registerSingleton(StreamIdentifierProvider());

    getIt.registerSingleton(StreamsPush());
    getIt.registerSingleton(EventsPush());

    getIt.registerSingleton(StreamsService());
    getIt.registerSingleton(EventsService());
    getIt.registerSingleton(RegistryService());

    getIt.registerSingleton(StreamsBackend());
    getIt.registerSingleton(EventsBackend());
    getIt.registerSingleton(RegistryBackend());
    _initialized = true;
  }
}
