import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/streams/client.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class StreamsViewModel {
  final BehaviorSubject<List<StreamEntryDto>> _streams =
      BehaviorSubject<List<StreamEntryDto>>();

  late final StreamSubscription<StreamEventDto> _registrationSubscriptions;
  late final StreamSubscription<StreamUpdatedEventDto> _updateSubscriptions;
  late final StreamSubscription<ConnectedState> _clientConnectedSubscription;
  Stream<List<StreamEntryDto>> get streams => _streams.stream;

  final StreamsClient _streamsClient = getIt.get<StreamsClient>();
  final _vmServiceProvider = getIt.get<VmServiceProvider>();

  StreamsViewModel() {
    _registrationSubscriptions =
        Rx.merge([_streamsClient.onRegistered, _streamsClient.onClosed])
            .listen((event) {
      refresh();
    });
    _updateSubscriptions =
        Rx.merge([_streamsClient.onUpdated, _streamsClient.onErrored])
            .listen((event) {
      final currentStreams = _streams.valueOrNull ?? [];
      final updatedStreams = currentStreams
          .map(
            (stream) => stream.id == event.streamId ? event.entry : stream,
          )
          .toList();
      _streams.add(updatedStreams);
    });
    _clientConnectedSubscription =
        _vmServiceProvider.connectedState.listen((state) {
      if (state.connected) {
        refresh();
      }
    });
  }

  void dispose() {
    _registrationSubscriptions.cancel();
    _updateSubscriptions.cancel();
    _clientConnectedSubscription.cancel();
  }

  void refresh() {
    _streamsClient.listStreamEntries().then((entries) {
      _streams.add(entries);
    });
  }
}
