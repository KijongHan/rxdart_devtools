/// Service-extension method names for the registry feature.
abstract final class RegistryConstants {
  /// Method name for injecting a parsed value into a tracked subject.
  static const String inject = 'ext.rxdart.inject';

  /// Method name for injecting an error into a tracked subject.
  static const String injectError = 'ext.rxdart.injectError';

  /// Method name for clearing all currently-registered streams.
  static const String clearAll = 'ext.rxdart.clearAll';
}
