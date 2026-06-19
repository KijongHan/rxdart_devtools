import 'dart:async';
import 'package:rxdart_devtools/src/services/streams.dart';
import 'package:rxdart_devtools/src/types/registry.dart';
import 'package:uuid/uuid.dart';
import '../types/streams.dart';

class Registry {
  Registry._();

  static final Registry instance = Registry._();

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
        Streams.instance.updateValue(identifier, value);
      },
      onDone: () {
        _subscriptions[identifier]?.cancel();
        _subscriptions.remove(identifier);
        Streams.instance.remove(identifier);
      },
      onError: (Object error, stackTrace) {
        Streams.instance.updateError(identifier, error);
      },
    );

    Streams.instance.insertEntry<dynamic>(identifier);
    _subscriptions[identifier] = subscription;
  }
}
