import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';

import 'event_tile.dart';

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
        return EventTile(key: ValueKey(log.id), log: log);
      },
    );
  }
}
