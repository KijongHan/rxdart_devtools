import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/sdk/types.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

extension SubjectInjectionExtension<T, S extends Subject<T>>
    on TrackedSubject<T, S> {
  TrackedSubject<T, S> enableInjection({
    required T Function(String raw) parse,
  }) {
    if (identifier == null || kReleaseMode) return this;

    getIt
        .get<RegistryService>()
        .enableInjection<T>(asSubject(), parse, identifier!);
    return this;
  }
}
