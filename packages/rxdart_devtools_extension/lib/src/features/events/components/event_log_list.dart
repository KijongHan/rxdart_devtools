import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';

import 'event_log_tile.dart';

class EventsList extends StatelessWidget {
  const EventsList({super.key, required this.eventLogs});

  final List<EventLogDto> eventLogs;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: eventLogs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final log = eventLogs[index];
        return EventLogTile(key: ValueKey(log.id), log: log);
      },
    );
  }
}
