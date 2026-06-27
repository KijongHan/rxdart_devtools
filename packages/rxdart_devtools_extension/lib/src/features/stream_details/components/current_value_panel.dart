import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/shared/spacing.dart';

class CurrentValuePanel extends StatelessWidget {
  const CurrentValuePanel({super.key, required this.value});

  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current value',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.hintColor,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            _body(theme),
          ],
        ),
      ),
    );
  }

  Widget _body(ThemeData theme) {
    final raw = value;
    if (raw == null) {
      return Text(
        'No value yet',
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
      );
    }
    return SelectableText(
      raw,
      style: theme.textTheme.bodyMedium,
    );
  }
}
