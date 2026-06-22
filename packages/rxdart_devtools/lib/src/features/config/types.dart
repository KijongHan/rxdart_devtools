import 'package:rxdart_devtools/src/features/registry/types.dart';

final class SdkConfig {
  const SdkConfig({
    this.historySize = 20,
    this.closedEntryCap = 256,
    this.captureStackTraces = true,
    this.enabled = true,
    this.streamIdentifierStrategy = StreamIdentifierStrategy.name,
  });

  final int historySize;
  final int closedEntryCap;
  final bool captureStackTraces;
  final bool enabled;
  final StreamIdentifierStrategy streamIdentifierStrategy;
}
