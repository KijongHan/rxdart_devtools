import 'dart:convert';
import 'dart:developer' as developer;

import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:rxdart_devtools/src/features/streams/service.dart';
import 'package:rxdart_devtools/src/features/streams/dto.dart';
import 'constants.dart';

final class StreamsBackend {
  final streamsService = getIt.get<StreamsService>();

  StreamsBackend() {
    developer.registerExtension(
        StreamsConstants.listStreamEntries, _handleListStreamEntries);
    developer.registerExtension(
        StreamsConstants.clearClosed, _handleClearClosed);
  }

  Future<developer.ServiceExtensionResponse> _handleListStreamEntries(
    String method,
    Map<String, String> parameters,
  ) async {
    final response = ListStreamEntriesResponseDto(
      entries: streamsService.all.map(StreamEntryDto.fromEntry).toList(),
    );
    return developer.ServiceExtensionResponse.result(
      jsonEncode(response.toJson()),
    );
  }

  Future<developer.ServiceExtensionResponse> _handleClearClosed(
    String method,
    Map<String, String> parameters,
  ) async {
    streamsService.clearClosed();
    return developer.ServiceExtensionResponse.result(jsonEncode({'ok': true}));
  }
}
