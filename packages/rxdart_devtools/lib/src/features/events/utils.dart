import 'package:collection/collection.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools/src/features/events/types.dart';

extension BaseEventLogIterableX on Iterable<BaseEventLog> {
  Iterable<BaseEventLog> sortedByRequest(SortRequestDto sortRequest) {
    final sortField = sortRequest.sortField ?? SortField.timestamp;
    final sortDirection = sortRequest.sortDirection ?? SortDirection.descending;

    return sorted((a, b) {
      final (x, y) = sortDirection == SortDirection.ascending ? (a, b) : (b, a);
      return switch (sortField) {
        SortField.timestamp => x.eventLogIdentifier.timestamp
            .compareTo(y.eventLogIdentifier.timestamp),
        SortField.streamId =>
          x.streamIdentifier.id.compareTo(y.streamIdentifier.id),
        SortField.lastUpdated => x.eventLogIdentifier.timestamp
            .compareTo(y.eventLogIdentifier.timestamp),
      };
    });
  }
}
