import 'package:flutter/foundation.dart';

import 'registry.dart';

extension RxDartDevtoolsTracking<T> on Stream<T> {
  Stream<T> tracked(String? name, {int? historySize}) {
    if (kReleaseMode) return this;
    return _trackImpl(name, historySize);
  }

  Stream<T> _trackImpl(String? name, int? historySize) {
    Registry.instance.register<T>(this, name: name, historySize: historySize);
    return this;
  }
}
