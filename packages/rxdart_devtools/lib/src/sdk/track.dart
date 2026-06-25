import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/sdk/types.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

StreamIdentifier? _registerForTracking<T>(
  Stream<T> stream,
  String name,
  int? historySize,
) {
  if (kReleaseMode) return null;
  if (name.isEmpty) {
    throw ArgumentError('name cannot be empty');
  }
  return getIt.get<RegistryService>().register<T>(
    stream,
    (name: name, historySize: historySize),
  );
}

extension StreamTrackingExtension<T> on Stream<T> {
  TrackedStream<T> track(String name, {int? historySize}) {
    _registerForTracking<T>(this, name, historySize);
    return TrackedStream(this);
  }
}

extension SubjectTrackingExtension<T, S extends Subject<T>> on S {
  TrackedSubject<T, S> track(String name, {int? historySize}) {
    final id = _registerForTracking<T>(this, name, historySize);
    return TrackedSubject(this, id);
  }
}
