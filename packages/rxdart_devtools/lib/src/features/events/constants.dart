/// Service-extension method and event names for the events feature.
abstract final class EventsConstants {
  /// Method name for fetching the full event log.
  static const String listEventLogs = 'ext.rxdart.listEventLogs';

  /// Event name pushed when a new event log entry is recorded.
  static const String eventAdded = 'ext.rxdart.eventAdded';
}
