import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';

extension RxDartDevtoolsTracking<T, S extends Stream<T>> on S {
  S track(String name, {int? historySize}) {
    if (kReleaseMode) return this;

    if (name.isEmpty) {
      throw ArgumentError('name cannot be empty');
    }

    GetIt.I
        .get<RegistryService>()
        .register<T>(this, (name: name, historySize: historySize));
    return this;
  }
}
