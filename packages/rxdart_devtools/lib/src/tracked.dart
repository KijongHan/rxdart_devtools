import 'package:flutter/foundation.dart';

import 'registry.dart';

extension RxDartDevtoolsTracking<T, S extends Stream<T>> on S {
  S tracked(String? name, {int? historySize}) {
    if (kReleaseMode) return this;

    Registry.instance.register<T>(this, name: name, historySize: historySize);
    return this;
  }
}
