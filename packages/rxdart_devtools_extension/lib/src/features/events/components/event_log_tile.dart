import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/shared/utils.dart';

class EventLogTile extends StatelessWidget {
  const EventLogTile({
    super.key,
    required this.log,
    this.onTap,
    this.selected = false,
    this.showStreamName = true,
  });

  final EventLogDto log;
  final VoidCallback? onTap;
  final bool selected;
  final bool showStreamName;

  @override
  Widget build(BuildContext context) {
    final (label, detail, color) = switch (log) {
      ChangeEventLogDto(:final newValue, :final oldValue) => (
          'change',
          '${oldValue ?? '—'} → ${newValue ?? '—'}',
          Colors.blue,
        ),
      ErrorEventLogDto(:final error) => (
          'error',
          error,
          Colors.red,
        ),
      RegisterEventLogDto() => (
          'register',
          '',
          Colors.green,
        ),
      DeregisterEventLogDto() => (
          'deregister',
          '',
          Colors.grey,
        ),
    };

    final Widget? title;
    final Widget? subtitle;
    if (showStreamName) {
      title = Text(log.streamId);
      subtitle = detail.isEmpty ? null : Text(detail);
    } else {
      title = detail.isEmpty ? null : Text(detail);
      subtitle = null;
    }

    return ListTile(
      dense: true,
      onTap: onTap,
      selected: selected,
      leading: _Badge(label: label, color: color),
      title: title,
      subtitle: subtitle,
      trailing: Tooltip(
        message: DateTimeUtils.fullTimestamp(log.timestamp),
        waitDuration: const Duration(milliseconds: 300),
        child: Text(
          DateTimeUtils.shortTimestamp(log.timestamp),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
