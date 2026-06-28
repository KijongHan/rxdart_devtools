import 'package:rxdart_devtools_example/src/features/primitive_subjects/page.dart';
import 'package:rxdart_devtools_example/src/shared/types.dart';

final Example primitiveSubjectsExample = Example(
  id: 'primitive-subjects',
  title: 'Primitive subjects',
  description:
      'Showcase BehaviorSubject, PublishSubject, and ReplaySubject behaviours '
      'side by side.',
  builder: (_) => const PrimitiveSubjectsExamplePage(),
);
