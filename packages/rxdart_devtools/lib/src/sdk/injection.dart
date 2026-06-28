import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/sdk/types.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

/// Adds the panel-injection API to [TrackedSubject].
///
/// Note: the active implementation lives as a method on [TrackedSubject]
/// itself (see `types.dart`); that instance method shadows this extension.
/// Kept here as a forward-compatible surface for when the class method moves
/// out into an extension.
extension SubjectInjectionExtension<T, S extends Subject<T>>
    on TrackedSubject<T, S> {
  /// See [TrackedSubject.enableInjection].
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
