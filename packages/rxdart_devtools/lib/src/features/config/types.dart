import 'package:rxdart_devtools/src/features/registry/types.dart';

final class SdkConfig {
  const SdkConfig({
    this.streamIdentifierStrategy = StreamIdentifierStrategy.name,
  });

  final StreamIdentifierStrategy streamIdentifierStrategy;
}
