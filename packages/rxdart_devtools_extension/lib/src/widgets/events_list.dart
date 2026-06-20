import 'package:flutter/material.dart';
import 'package:rxdart_devtools/rxdart_devtools_dto.dart';

class EventsList extends StatelessWidget {
  const EventsList({required this.eventLogs, super.key});

  final List<EventLogDto> eventLogs;

  @override
  Widget build(BuildContext context) {
    if (eventLogs.isEmpty) {
      return const Center(
        child: Text('No events yet'),
      );
    }
    return ListView.separated(
      itemCount: eventLogs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final log = eventLogs[index];
        return _EventTile(log: log);
      },
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.log});

  final EventLogDto log;

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
      leading: _Badge(label: label, color: color),
      title: Text(_streamIdOf(log)),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: Text(
        _shortTimestamp(_timestampOf(log)),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  static String _streamIdOf(EventLogDto log) => switch (log) {
        ChangeEventLogDto(:final streamId) => streamId,
        ErrorEventLogDto(:final streamId) => streamId,
        RegisterEventLogDto(:final streamId) => streamId,
        DeregisterEventLogDto(:final streamId) => streamId,
      };

  static String _timestampOf(EventLogDto log) => switch (log) {
        ChangeEventLogDto(:final timestamp) => timestamp,
        ErrorEventLogDto(:final timestamp) => timestamp,
        RegisterEventLogDto(:final timestamp) => timestamp,
        DeregisterEventLogDto(:final timestamp) => timestamp,
      };

  static String _shortTimestamp(String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return iso;
    final h = parsed.hour.toString().padLeft(2, '0');
    final m = parsed.minute.toString().padLeft(2, '0');
    final s = parsed.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
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
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
