import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/components/event_log_tile.dart';

class SelectedStreamEventLogs extends StatelessWidget {
  const SelectedStreamEventLogs({super.key, required this.eventLogs});

  final List<EventLogDto> eventLogs;

  @override
  Widget build(BuildContext context) {
    if (eventLogs.isEmpty) {
      return const Center(child: Text('No events for this stream'));
    }
    return ListView.separated(
      itemCount: eventLogs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final log = eventLogs[index];
        return EventLogTile(
          key: ValueKey(log.id),
          log: log,
          showStreamName: false,
        );
      },
    );
  }
}
