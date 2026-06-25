import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

class TrackedStream<T> {
  TrackedStream(this._stream);

  final Stream<T> _stream;

  Stream<T> asStream() => _stream;
}

class TrackedSubject<T, S extends Subject<T>> {
  TrackedSubject(this._subject, this.identifier);

  final S _subject;
  final StreamIdentifier? identifier;

  S asSubject() => _subject;

  TrackedSubject<T, S> enableInjection({
    required T? Function(String raw) parse,
  }) {
    final id = identifier;
    if (id == null) return this;

    getIt.get<RegistryService>().enableInjection<T>(_subject, parse, id);
    return this;
  }
}
