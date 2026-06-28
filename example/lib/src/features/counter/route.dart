import 'package:rxdart_devtools_example/src/features/counter/page.dart';
import 'package:rxdart_devtools_example/src/shared/types.dart';

final Example counterExample = Example(
  id: 'counter',
  title: 'Auto-incrementing counter',
  description:
      'A BehaviorSubject<int> driven by a Timer.periodic that emits the next '
      'value every second. Pause/resume to control the emission stream.',
  builder: (_) => const CounterExamplePage(),
);
