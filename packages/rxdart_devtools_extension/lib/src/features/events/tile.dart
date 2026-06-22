import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.log,
    this.onTap,
    this.selected = false,
  });

  final EventLogDto log;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final (label, subtitle, color) = switch (log) {
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

    return ListTile(
      dense: true,
      onTap: onTap,
      selected: selected,
      leading: _Badge(label: label, color: color),
      title: Text(log.streamId),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: Text(
        shortTimestamp(log.timestamp),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

String shortTimestamp(String iso) {
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return iso;
  final h = parsed.hour.toString().padLeft(2, '0');
  final m = parsed.minute.toString().padLeft(2, '0');
  final s = parsed.second.toString().padLeft(2, '0');
  return '$h:$m:$s';
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
