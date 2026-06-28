/// Service-extension method and event names for the streams feature.
abstract final class StreamsConstants {
  /// Method name for listing currently-tracked stream entries.
  static const String listStreamEntries = 'ext.rxdart.listStreamEntries';

  /// Event name pushed when a new stream is registered with the runtime.
  static const String streamRegistered = 'ext.rxdart.streamRegistered';

  /// Event name pushed when a tracked stream completes / closes.
  static const String streamClosed = 'ext.rxdart.streamClosed';

  /// Event name pushed when a tracked stream emits a new value.
  static const String streamUpdated = 'ext.rxdart.streamUpdated';

  /// Event name pushed when a tracked stream emits an error.
  static const String streamErrored = 'ext.rxdart.streamErrored';
}
