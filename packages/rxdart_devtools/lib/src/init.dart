import 'package:flutter/foundation.dart';

import 'lifecycle.dart';
import 'service_extensions.dart';

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
  static RxDartDevtoolsConfig _config = const RxDartDevtoolsConfig();
  static bool _initialized = false;

  static RxDartDevtoolsConfig get config => _config;

  static void init({
    int historySize = 20,
    int closedEntryCap = 256,
    bool captureStackTraces = true,
    bool enabled = true,
  }) {
    if (kReleaseMode) return;
    _config = RxDartDevtoolsConfig(
      historySize: historySize,
      closedEntryCap: closedEntryCap,
      captureStackTraces: captureStackTraces,
      enabled: enabled,
    );
    if (_initialized) return;
    _initialized = true;
    ServiceExtensions.register();
    Lifecycle.install();
  }
}
