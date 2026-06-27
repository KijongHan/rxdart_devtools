import 'package:flutter/widgets.dart';

/// Metadata + builder for a single example shown in the demo app.
class Example {
  const Example({
    required this.id,
    required this.title,
    required this.description,
    required this.builder,
  });

  final String id;
  final String title;
  final String description;
  final WidgetBuilder builder;
}
