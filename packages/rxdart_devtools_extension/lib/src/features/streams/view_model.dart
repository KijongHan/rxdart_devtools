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
  static const _searchDebounce = Duration(milliseconds: 300);

  final _streamDetailsRepository = getIt.get<StreamDetailsRepository>();
  final _streamsRepository = getIt.get<StreamsRepository>();

  final _searchQuery = BehaviorSubject<String>();
  final _filteredStreams = BehaviorSubject<List<StreamEntryDto>>();
  late final StreamSubscription<List<StreamEntryDto>>
      _filteredStreamsSubscription;

  Stream<List<StreamEntryDto>> get filteredStreams => _filteredStreams.stream;

  final _viewState = BehaviorSubject<StreamsViewState>();
  late final StreamSubscription<StreamsViewState> _viewStateSubscription;

  Stream<StreamsViewState> get viewState => _viewState.stream;

  StreamsViewModel() {
    _filteredStreamsSubscription = Rx.combineLatest2(
      _streamsRepository.streams,
      _searchQuery.debounceTime(_searchDebounce).startWith(''),
      _filter,
    ).listen(_filteredStreams.add);

    _viewStateSubscription = Rx.combineLatest2(
      _filteredStreams,
      _streamDetailsRepository.selectedStreamId,
      (streams, selectedStreamId) => (
        streams: streams,
        selectedStreamId: selectedStreamId,
      ),
    ).listen((state) {
      _viewState.add(state);
    });
  }

  void setSearchQuery(String query) => _searchQuery.add(query);

  List<StreamEntryDto> _filter(List<StreamEntryDto> streams, String query) {
    if (query.isEmpty) return streams;
    final needle = query.toLowerCase();
    return streams.where((stream) => _matches(stream, needle)).toList();
  }

  bool _matches(StreamEntryDto stream, String needle) {
    if (stream.name.toLowerCase().contains(needle)) return true;
    return false;
  }

  void dispose() {
    _viewStateSubscription.cancel();
    _filteredStreamsSubscription.cancel();
    _searchQuery.close();
    _filteredStreams.close();
    _viewState.close();
  }
}
