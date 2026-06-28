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

/// Adds [track] to any [Stream] so its emissions appear in the DevTools panel.
extension StreamTrackingExtension<T> on Stream<T> {
  /// Registers this stream with the DevTools runtime under [name].
  ///
  /// Returns a [TrackedStream] wrapping the original stream; call
  /// [TrackedStream.asStream] to unwrap. In release builds this is a no-op —
  /// no subscription is taken and nothing is registered. Throws
  /// [ArgumentError] if [name] is empty.
  ///
  /// Optional [historySize] caps the number of past events the panel retains
  /// for this stream.
  TrackedStream<T> track(String name, {int? historySize}) {
    _registerForTracking<T>(this, name, historySize);
    return TrackedStream(this);
  }
}

/// Adds [track] to any rxdart [Subject] so its emissions appear in the
/// DevTools panel and the panel can drive values into it via
/// `enableInjection`.
extension SubjectTrackingExtension<T, S extends Subject<T>> on S {
  /// Registers this subject with the DevTools runtime under [name].
  ///
  /// Returns a [TrackedSubject] preserving the original Subject subtype; call
  /// [TrackedSubject.asSubject] to unwrap, or chain `.enableInjection(...)` to
  /// allow the panel to push values into the subject. In release builds this
  /// is a no-op. Throws [ArgumentError] if [name] is empty.
  ///
  /// Optional [historySize] caps the number of past events the panel retains
  /// for this subject.
  TrackedSubject<T, S> track(String name, {int? historySize}) {
    final id = _registerForTracking<T>(this, name, historySize);
    return TrackedSubject(this, id);
  }
}
