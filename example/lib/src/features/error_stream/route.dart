import 'package:rxdart_devtools_example/src/features/error_stream/page.dart';
import 'package:rxdart_devtools_example/src/shared/types.dart';

final Example errorStreamExample = Example(
  id: 'error-stream',
  title: 'Stream errors',
  description:
      'Emit errors via addError() or by throwing inside a .map operator; the '
      'DevTools panel logs an error event for the affected tracked stream.',
  builder: (_) => const ErrorStreamExamplePage(),
);
