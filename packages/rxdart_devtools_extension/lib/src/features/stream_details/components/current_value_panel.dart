import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/shared/spacing.dart';

class CurrentValuePanel extends StatelessWidget {
  const CurrentValuePanel({super.key, required this.value});

  final String? value;

  static const _maxBodyHeight = 220.0;
  static final _jsonEncoder = JsonEncoder.withIndent('  ');

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

    final decoded = _tryDecode(raw);
    if (decoded is Map || decoded is List) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: _maxBodyHeight),
        child: SingleChildScrollView(
          child: SelectableText(
            _jsonEncoder.convert(decoded),
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              height: 1.4,
            ),
          ),
        ),
      );
    }

    return SelectableText(
      raw,
      style: theme.textTheme.bodyMedium,
    );
  }

  static Object? _tryDecode(String raw) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }
}
