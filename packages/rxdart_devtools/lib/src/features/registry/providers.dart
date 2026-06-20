import 'package:rxdart_devtools/src/devtools/init.dart';
import 'package:rxdart_devtools/src/features/registry/types.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/providers/config.dart';
import 'package:rxdart_devtools/src/providers/get_it.dart';
import 'package:uuid/uuid.dart';

final class StreamIdentifierProvider {
  final Uuid uuid = Uuid();
  final ConfigProvider configProvider = getIt.get<ConfigProvider>();

  StreamIdentifier generateStreamIdentifier<T>({
    required Stream<T> stream,
    required RegistryConfig registryConfig,
  }) =>
      StreamIdentifier(
        id: configProvider.config.streamIdentifierStrategy ==
                StreamIdentifierStrategy.uuid
            ? uuid.v4()
            : registryConfig.name,
        name: registryConfig.name,
        typeLabel: stream.runtimeType.toString(),
      );
}
