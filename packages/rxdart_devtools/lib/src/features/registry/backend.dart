import 'dart:convert';
import 'dart:developer' as developer;

import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools/src/features/events/service.dart';
import 'package:rxdart_devtools/src/features/registry/dto.dart';
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
    developer.registerExtension(
      RegistryConstants.inject,
      _handleInject,
    );
    developer.registerExtension(
      RegistryConstants.injectError,
      _handleInjectError,
    );
  }

  Future<developer.ServiceExtensionResponse> _handleInject(
    String method,
    Map<String, String> parameters,
  ) async {
    final request = InjectRequestDto.fromJson(parameters);
    final identifier = registryService.getStreamIdentifier(request.identifier);
    if (identifier == null) {
      return developer.ServiceExtensionResponse.error(
        404,
        'Stream not found',
      );
    }

    registryService.inject(identifier, request.raw);
    return developer.ServiceExtensionResponse.result(
      jsonEncode(OkResponseDto(ok: true).toJson()),
    );
  }

  Future<developer.ServiceExtensionResponse> _handleInjectError(
    String method,
    Map<String, String> parameters,
  ) async {
    final request = InjectErrorRequestDto.fromJson(parameters);
    final identifier = registryService.getStreamIdentifier(request.identifier);
    if (identifier == null) {
      return developer.ServiceExtensionResponse.error(
        404,
        'Stream not found',
      );
    }
    registryService.injectError(identifier, request.message);
    return developer.ServiceExtensionResponse.result(
      jsonEncode(OkResponseDto(ok: true).toJson()),
    );
  }

  Future<developer.ServiceExtensionResponse> _handleClearAll(
    String method,
    Map<String, String> parameters,
  ) async {
    await registryService.clear();
    eventsService.clear();
    streamsService.clear();
    return developer.ServiceExtensionResponse.result(
      jsonEncode(OkResponseDto(ok: true).toJson()),
    );
  }
}
