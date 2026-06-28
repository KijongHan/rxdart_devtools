import 'package:rxdart_devtools_example/src/features/registration/page.dart';
import 'package:rxdart_devtools_example/src/shared/types.dart';

final Example registrationExample = Example(
  id: 'registration',
  title: 'Registration & deregistration',
  description:
      'Create and dispose tracked subjects to observe lifecycle events '
      'in the rxdart DevTools panel.',
  builder: (_) => const RegistrationExamplePage(),
);
