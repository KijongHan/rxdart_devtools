import 'package:flutter/foundation.dart';
import 'package:rxdart_devtools/src/services/registry.dart';

extension RxDartDevtoolsTracking<T, S extends Stream<T>> on S {
  S track(String name, {int? historySize}) {
    if (kReleaseMode) return this;

    if (name.isEmpty) {
      throw ArgumentError('name cannot be empty');
    }

    Registry.instance.register<T>(this, (name: name, historySize: historySize));
    return this;
  }
}
