import 'package:rxdart_devtools_example/src/features/combine_latest/route.dart';
import 'package:rxdart_devtools_example/src/features/complex_subjects/route.dart';
import 'package:rxdart_devtools_example/src/features/counter/route.dart';
import 'package:rxdart_devtools_example/src/features/error_stream/route.dart';
import 'package:rxdart_devtools_example/src/features/injectable_subject/route.dart';
import 'package:rxdart_devtools_example/src/features/primitive_subjects/route.dart';
import 'package:rxdart_devtools_example/src/features/registration/route.dart';

import 'shared/types.dart';

final List<Example> examples = <Example>[
  registrationExample,
  primitiveSubjectsExample,
  complexSubjectsExample,
  injectableSubjectExample,
  combineLatestExample,
  counterExample,
  errorStreamExample,
];
