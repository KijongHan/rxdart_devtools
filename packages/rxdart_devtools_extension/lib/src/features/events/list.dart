import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

import 'components/event_log_tile.dart';

class EventsList extends StatefulWidget {
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  late final EventsViewModel _eventsViewModel;

  @override
  void initState() {
    super.initState();
    _eventsViewModel = getIt.get<EventsViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventLogDto>>(
      stream: _eventsViewModel.eventLogs,
      builder: (context, snapshot) {
        final eventLogs = snapshot.data ?? const [];
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
            return EventLogTile(key: ValueKey(log.id), log: log);
          },
        );
      },
    );
  }
}
