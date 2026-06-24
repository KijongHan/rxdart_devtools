import 'package:flutter/material.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({super.key, required this.child});

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
