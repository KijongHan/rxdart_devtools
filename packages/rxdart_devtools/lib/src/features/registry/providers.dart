import 'package:rxdart_devtools/src/features/registry/types.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/features/config/providers.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

final class StreamIdentifierProvider {
  final UuidProvider uuidProvider = getIt.get<UuidProvider>();
  final ConfigProvider configProvider = getIt.get<ConfigProvider>();

  (String id, StreamIdentifier identifier) generateStreamIdentifier<T>({
    required Stream<T> stream,
    required RegistryConfig registryConfig,
  }) {
    final id = configProvider.config.streamIdentifierStrategy ==
            StreamIdentifierStrategy.uuid
        ? uuidProvider.generate()
        : registryConfig.name;
    return (
      id,
      StreamIdentifier(
        id: id,
        name: registryConfig.name,
        typeLabel: stream.runtimeType.toString(),
      )
    );
  }
}
