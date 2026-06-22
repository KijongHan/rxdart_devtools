import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

final getIt = GetIt.instance;

final class DateTimeProvider {
  DateTime now() => DateTime.now();
}

final class UuidProvider {
  final Uuid _uuid = Uuid();

  String generate() => _uuid.v4();
}

// final class Lifecycle {
//   Lifecycle() {
//     WidgetsFlutterBinding.ensureInitialized();
//     WidgetsBinding.instance.addObserver(_HotReloadObserver());
//   }
// }

// class _HotReloadObserver with WidgetsBindingObserver {
//   final streamsService = getIt.get<StreamsService>();

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {}

//   // Hot reload — Flutter calls reassemble on every widget. The widgets binding
//   // fires didReassemble before propagation. We hook there to evict closed entries.
//   void didReassemble() {
//     streamsService.clearClosed();
//   }
// }
