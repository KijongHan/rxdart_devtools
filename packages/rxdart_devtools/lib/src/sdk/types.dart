import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

/// Wrapper returned by `Stream.track()` that lets you unwrap the original
/// [Stream] while keeping the call chain expressive.
class TrackedStream<T> {
  /// Creates a wrapper around [_stream]. Prefer calling `.track()` rather than
  /// constructing this directly.
  TrackedStream(this._stream);

  final Stream<T> _stream;

  /// Returns the underlying [Stream] unchanged.
  Stream<T> asStream() => _stream;
}

/// Wrapper returned by `Subject.track()` that preserves the original Subject
/// subtype and unlocks `enableInjection`.
class TrackedSubject<T, S extends Subject<T>> {
  /// Creates a wrapper around [_subject]. Prefer calling `.track()` rather
  /// than constructing this directly.
  TrackedSubject(this._subject, this.identifier);

  final S _subject;

  /// Runtime identifier the DevTools panel uses to address this subject.
  /// `null` in release builds (where tracking is disabled).
  final StreamIdentifier? identifier;

  /// Returns the underlying Subject (preserving its subtype — e.g.
  /// `BehaviorSubject<int>` stays a `BehaviorSubject<int>`).
  S asSubject() => _subject;

  /// Allows the DevTools panel to push values into the wrapped subject.
  ///
  /// [parse] converts the raw text from the panel's input into the subject's
  /// value type; returning `null` causes the panel to surface a parse error
  /// without changing the subject. No-op in release builds.
  TrackedSubject<T, S> enableInjection({
    required T? Function(String raw) parse,
  }) {
    final id = identifier;
    if (id == null) return this;

    getIt.get<RegistryService>().enableInjection<T>(_subject, parse, id);
    return this;
  }
}
