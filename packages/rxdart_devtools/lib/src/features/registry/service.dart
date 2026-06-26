import 'dart:async';
import 'package:result_dart/result_dart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/src/features/registry/providers.dart';
import 'package:rxdart_devtools/src/features/config/providers.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/streams/service.dart';
import 'package:rxdart_devtools/src/features/registry/types.dart';
import '../streams/types.dart';

class RegistryService {
  final configProvider = getIt.get<ConfigProvider>();
  final streamsService = getIt.get<StreamsService>();
  final eventsService = getIt.get<EventsService>();
  final streamIdentifierProvider = getIt.get<StreamIdentifierProvider>();

  final Map<StreamIdentifier, StreamSubscription<dynamic>> _subscriptions = {};
  final Map<String, StreamIdentifier> _streamIdentifiers = {};
  final Map<StreamIdentifier, SubjectInjector> _subjectInjectors = {};

  StreamIdentifier register<T>(
    Stream<T> stream,
    RegistryConfig registryConfig,
  ) {
    final (id, identifier) = streamIdentifierProvider.generateStreamIdentifier(
      stream: stream,
      registryConfig: registryConfig,
    );

    final subscription = stream.listen(
      (value) {
        streamsService.updateValue(identifier, value);
        eventsService.addValueEventLog(identifier, value);
      },
      onDone: () {
        _subscriptions[identifier]?.cancel();
        _subscriptions.remove(identifier);
        _subjectInjectors.remove(identifier);
        streamsService.deregisterStream(identifier);
        eventsService.deregisterStream(identifier);
      },
      onError: (Object error, stackTrace) {
        streamsService.updateError(identifier, error);
        eventsService.addErrorEventLog(identifier, error);
      },
    );

    streamsService.registerStream<dynamic>(
      identifier,
      isSubject: stream is Subject<T>,
    );
    eventsService.registerStream(identifier);
    _subscriptions[identifier] = subscription;
    _streamIdentifiers[id] = identifier;
    return identifier;
  }

  void enableInjection<T>(
    Subject<T> subject,
    T? Function(String raw) parse,
    StreamIdentifier identifier,
  ) {
    _subjectInjectors[identifier] = SubjectInjector(
      add: (raw) {
        final value = parse(raw);
        if (value == null) {
          return Failure(FormatException(
            "Could not parse '$raw' as ${identifier.typeLabel}",
          ));
        }
        subject.add(value);
        return Success.unit();
      },
      addError: (message) {
        subject.addError(message);
        return Success.unit();
      },
    );
    streamsService.markInjectable(identifier);
  }

  Result<void> inject(StreamIdentifier identifier, String raw) =>
      _subjectInjectors[identifier]?.add(raw) ??
      Failure(Exception(
        "Could not inject value into '$identifier'",
      ));

  Result<void> injectError(StreamIdentifier identifier, String message) =>
      _subjectInjectors[identifier]?.addError(message) ??
      Failure(Exception(
        "Could not inject error into '$identifier'",
      ));

  StreamIdentifier? getStreamIdentifier(String id) => _streamIdentifiers[id];

  Future<void> clear() async {
    for (final subscription in _subscriptions.values) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    _streamIdentifiers.clear();
    _subjectInjectors.clear();
  }
}
