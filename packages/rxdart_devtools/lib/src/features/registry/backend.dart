import 'dart:convert';
import 'dart:developer' as developer;

import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/registry/constants.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/features/streams/service.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

final class RegistryBackend {
  final registryService = getIt.get<RegistryService>();
  final streamsService = getIt.get<StreamsService>();
  final eventsService = getIt.get<EventsService>();

  RegistryBackend() {
    developer.registerExtension(
      RegistryConstants.clearAll,
      _handleClearAll,
    );
  }

  Future<developer.ServiceExtensionResponse> _handleClearAll(
    String method,
    Map<String, String> parameters,
  ) async {
    await registryService.clear();
    eventsService.clear();
    streamsService.clear();
    return developer.ServiceExtensionResponse.result(jsonEncode({'ok': true}));
  }
}
