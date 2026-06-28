import 'package:rxdart_devtools_example/src/features/complex_subjects/page.dart';
import 'package:rxdart_devtools_example/src/shared/types.dart';

final Example complexSubjectsExample = Example(
  id: 'complex-subjects',
  title: 'Complex subjects',
  description:
      'How Map, List, and custom classes (with/without toJson) render in '
      'the panel.',
  builder: (_) => const ComplexSubjectsExamplePage(),
);
