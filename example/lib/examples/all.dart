import 'package:flutter/widgets.dart';

import 'complex_subjects.dart';
import 'example.dart';
import 'injectable_subject.dart';
import 'primitive_subjects.dart';
import 'registration.dart';

/// Central list of every example surfaced on the home page.
/// Add new entries here as the demo grows.
const List<Example> kExamples = <Example>[
  Example(
    id: 'registration',
    title: 'Registration & deregistration',
    description:
        'Create and dispose tracked subjects to observe lifecycle events '
        'in the rxdart DevTools panel.',
    builder: _buildRegistration,
  ),
  Example(
    id: 'primitive-subjects',
    title: 'Primitive subjects',
    description:
        'Showcase BehaviorSubject, PublishSubject, and ReplaySubject behaviours '
        'side by side.',
    builder: _buildPrimitiveSubjects,
  ),
  Example(
    id: 'complex-subjects',
    title: 'Complex subjects',
    description:
        'How Map, List, and custom classes (with/without toJson) render in '
        'the panel.',
    builder: _buildComplexSubjects,
  ),
  Example(
    id: 'injectable-subject',
    title: 'Injectable subject',
    description:
        'A BehaviorSubject<int> that the DevTools panel can push values '
        'into via enableInjection().',
    builder: _buildInjectableSubject,
  ),
];

Widget _buildRegistration(BuildContext context) => const RegistrationExample();
Widget _buildPrimitiveSubjects(BuildContext context) =>
    const PrimitiveSubjectsExample();
Widget _buildComplexSubjects(BuildContext context) =>
    const ComplexSubjectsExample();
Widget _buildInjectableSubject(BuildContext context) =>
    const InjectableSubjectExample();
