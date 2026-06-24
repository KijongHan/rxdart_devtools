import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/repository.dart';
import 'package:rxdart_devtools_extension/src/features/streams/repository.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

typedef StreamsViewState = ({
  List<StreamEntryDto> streams,
  String? selectedStreamId,
});

class StreamsViewModel {
  final _streamDetailsRepository = getIt.get<StreamDetailsRepository>();
  final _streamsRepository = getIt.get<StreamsRepository>();

  late final Stream<StreamsViewState> viewState = Rx.combineLatest2(
    _streamsRepository.streams,
    _streamDetailsRepository.selectedStreamId,
    (streams, selectedStreamId) => (
      streams: streams,
      selectedStreamId: selectedStreamId,
    ),
  );
}
