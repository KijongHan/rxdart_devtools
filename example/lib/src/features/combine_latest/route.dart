import 'package:rxdart_devtools_example/src/features/combine_latest/page.dart';
import 'package:rxdart_devtools_example/src/shared/types.dart';

final Example combineLatestExample = Example(
  id: 'combine-latest',
  title: 'Rx.combineLatest',
  description:
      'Two injectable BehaviorSubjects feeding a derived sum stream via '
      'Rx.combineLatest2; the combined output is tracked as read-only.',
  builder: (_) => const CombineLatestExamplePage(),
);
