import 'dart:async';
import 'package:rxdart_devtools/src/providers/get_it.dart';
import 'package:rxdart_devtools/src/services/events.dart';
import 'package:rxdart_devtools/src/services/streams.dart';
import 'package:rxdart_devtools/src/types/registry.dart';
import 'package:uuid/uuid.dart';
import '../types/streams.dart';

class RegistryService {
  final streamsService = getIt.get<StreamsService>();
  final eventsService = getIt.get<EventsService>();
  final Uuid uuid = Uuid();

  final Map<StreamIdentifier, StreamSubscription<dynamic>> _subscriptions = {};

  void register<T>(
    Stream<T> stream,
    RegistryConfig config,
  ) {
    final (:name, :historySize) = config;
    final identifier = StreamIdentifier(
      id: uuid.v4(),
      name: name,
      typeLabel: stream.runtimeType.toString(),
    );

    final subscription = stream.listen(
      (value) {
        streamsService.updateValue(identifier, value);
        eventsService.addValueEventLog(identifier, value);
      },
      onDone: () {
        _subscriptions[identifier]?.cancel();
        _subscriptions.remove(identifier);
        streamsService.deregisterStream(identifier);
        eventsService.deregisterStream(identifier);
      },
      onError: (Object error, stackTrace) {
        streamsService.updateError(identifier, error);
        eventsService.addErrorEventLog(identifier, error);
      },
    );

    streamsService.registerStream<dynamic>(identifier);
    eventsService.registerStream(identifier);
    _subscriptions[identifier] = subscription;
  }
}
