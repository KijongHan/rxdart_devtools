import 'package:result_dart/result_dart.dart';
import 'package:rxdart_devtools_extension/src/features/events/repository.dart';
import 'package:rxdart_devtools_extension/src/features/registry/client.dart';
import 'package:rxdart_devtools_extension/src/features/streams/repository.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

final class RegistryRepository {
  final _registryClient = getIt.get<RegistryClient>();
  final _streamsRepository = getIt.get<StreamsRepository>();
  final _eventsRepository = getIt.get<EventsRepository>();

  Future<Result<void>> clearAll() async {
    final response = await _registryClient.clearAll();
    return response.fold(
      (success) {
        _streamsRepository.refresh();
        _eventsRepository.refresh();
        return Success.unit();
      },
      (failure) => Failure(failure),
    );
  }
}
