import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/src/features/registry/service.dart';
import 'package:rxdart_devtools/src/sdk/types.dart';
import 'package:rxdart_devtools/src/shared/providers.dart';

extension SubjectInjectionExtension<T, S extends Subject<T>>
    on TrackedSubject<T, S> {
  TrackedSubject<T, S> enableInjection({
    required T Function(String raw) parse,
  }) {
    if (identifier == null) return this;

    getIt
        .get<RegistryService>()
        .enableInjection<T>(asSubject(), parse, identifier!);
    return this;
  }
}

// extension IntSubjectInjectionExtension<int, S extends Subject<int>>
//     on TrackedSubject<int, S> {
//   TrackedSubject<int, S> enableInjection({
//     required int Function(String raw) parse,
//   }) {
//     return enableInjection(parse: );
//   }
// }
