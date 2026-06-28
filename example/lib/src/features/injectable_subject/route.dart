import 'package:rxdart_devtools_example/src/features/injectable_subject/page.dart';
import 'package:rxdart_devtools_example/src/shared/types.dart';

final Example injectableSubjectExample = Example(
  id: 'injectable-subject',
  title: 'Injectable subject',
  description:
      'A BehaviorSubject<int> that the DevTools panel can push values '
      'into via enableInjection().',
  builder: (_) => const InjectableSubjectExamplePage(),
);
