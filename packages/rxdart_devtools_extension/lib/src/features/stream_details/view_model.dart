import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/repository.dart';
import 'package:rxdart_devtools_extension/src/features/streams/repository.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

typedef StreamDetailsViewState = ({
  String? selectedStreamId,
  StreamEntryDto? selectedStream,
  List<EventLogDto> eventLogs,
});

class StreamDetailsViewModel {
  final _streamDetailsRepository = getIt.get<StreamDetailsRepository>();
  final _streamsRepository = getIt.get<StreamsRepository>();

  late final Stream<StreamDetailsViewState> viewState = Rx.combineLatest3(
    _streamDetailsRepository.selectedStreamId,
    _streamsRepository.streams,
    _streamDetailsRepository.eventLogs,
    (selectedStreamId, streams, eventLogs) => (
      selectedStreamId: selectedStreamId,
      selectedStream:
          streams.where((s) => s.id == selectedStreamId).firstOrNull,
      eventLogs: eventLogs,
    ),
  );
}
