import 'package:flutter/material.dart';

class PanelTheme extends StatelessWidget {
  const PanelTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: child,
        ),
      ),
    );
  }
}
