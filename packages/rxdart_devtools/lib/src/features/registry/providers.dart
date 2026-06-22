import 'package:rxdart_devtools/src/sdk/init.dart';
import 'package:rxdart_devtools/src/features/registry/types.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/features/config/providers.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';
import 'package:uuid/uuid.dart';

final class StreamIdentifierProvider {
  final Uuid uuid = Uuid();
  final ConfigProvider configProvider = getIt.get<ConfigProvider>();

  (String id, StreamIdentifier identifier) generateStreamIdentifier<T>({
    required Stream<T> stream,
    required RegistryConfig registryConfig,
  }) {
    final id = configProvider.config.streamIdentifierStrategy ==
            StreamIdentifierStrategy.uuid
        ? uuid.v4()
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
