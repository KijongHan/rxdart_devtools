import 'package:flutter/widgets.dart';

import 'combine_latest.dart';
import 'complex_subjects.dart';
import 'counter.dart';
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
  Example(
    id: 'combine-latest',
    title: 'Rx.combineLatest',
    description:
        'Two injectable BehaviorSubjects feeding a derived sum stream via '
        'Rx.combineLatest2; the combined output is tracked as read-only.',
    builder: _buildCombineLatest,
  ),
  Example(
    id: 'counter',
    title: 'Auto-incrementing counter',
    description:
        'A BehaviorSubject<int> driven by a Timer.periodic that emits the next '
        'value every second. Pause/resume to control the emission stream.',
    builder: _buildCounter,
  ),
];

Widget _buildRegistration(BuildContext context) => const RegistrationExample();
Widget _buildPrimitiveSubjects(BuildContext context) =>
    const PrimitiveSubjectsExample();
Widget _buildComplexSubjects(BuildContext context) =>
    const ComplexSubjectsExample();
Widget _buildInjectableSubject(BuildContext context) =>
    const InjectableSubjectExample();
Widget _buildCombineLatest(BuildContext context) =>
    const CombineLatestExample();
Widget _buildCounter(BuildContext context) => const CounterExample();
