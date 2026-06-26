import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/repository.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

final class EventsViewModel {
  static const _searchDebounce = Duration(milliseconds: 300);

  final _eventsRepository = getIt.get<EventsRepository>();
  final _searchQuery = BehaviorSubject<String>();
  final _filteredEventLogs = BehaviorSubject<List<EventLogDto>>();
  late final StreamSubscription<List<EventLogDto>>
      _filteredEventLogsSubscription;

  Stream<List<EventLogDto>> get filteredEventLogs => _filteredEventLogs.stream;

  EventsViewModel() {
    _filteredEventLogsSubscription = Rx.combineLatest2(
      _eventsRepository.eventLogs,
      _searchQuery.debounceTime(_searchDebounce).startWith(''),
      _filter,
    ).listen(_filteredEventLogs.add);
  }

  void setSearchQuery(String query) => _searchQuery.add(query);

  List<EventLogDto> _filter(List<EventLogDto> eventLogs, String query) {
    if (query.isEmpty) return eventLogs;
    final needle = query.toLowerCase();
    return eventLogs.where((log) => _matches(log, needle)).toList();
  }

  bool _matches(EventLogDto log, String needle) {
    if (log.streamId.toLowerCase().contains(needle)) return true;
    return switch (log) {
      ChangeEventLogDto(:final newValue, :final oldValue) =>
        (newValue?.toLowerCase().contains(needle) ?? false) ||
            (oldValue?.toLowerCase().contains(needle) ?? false),
      ErrorEventLogDto(:final error) => error.toLowerCase().contains(needle),
      RegisterEventLogDto() || DeregisterEventLogDto() => false,
    };
  }

  void dispose() {
    _filteredEventLogsSubscription.cancel();
    _searchQuery.close();
    _filteredEventLogs.close();
  }
}
