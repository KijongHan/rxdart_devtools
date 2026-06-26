import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/shared/spacing.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stream, size: 48, color: Theme.of(context).disabledColor),
          const SizedBox(height: Spacing.md),
          const Text('No tracked streams'),
          const SizedBox(height: 4),
          Text(
            'Call .track() on a Subject or Stream to see it here.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
