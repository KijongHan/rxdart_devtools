import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/components/event_log_list.dart';
import 'package:rxdart_devtools_extension/src/features/events/components/event_log_list_header.dart';
import 'package:rxdart_devtools_extension/src/features/events/repository.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:rxdart_devtools_extension/src/shared/spacing.dart';

class EventsPanel extends StatefulWidget {
  const EventsPanel({super.key});

  @override
  State<EventsPanel> createState() => _EventsPanelState();
}

class _EventsPanelState extends State<EventsPanel> {
  late final EventsRepository _eventsRepository;
  bool _ascending = false;

  @override
  void initState() {
    super.initState();
    _eventsRepository = getIt.get<EventsRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventLogDto>>(
      stream: _eventsRepository.eventLogs,
      builder: (context, snapshot) {
        final eventLogs = snapshot.data ?? const [];
        final sorted = [...eventLogs]..sort(
            (a, b) => _ascending
                ? a.timestamp.compareTo(b.timestamp)
                : b.timestamp.compareTo(a.timestamp),
          );
        final content = sorted.isEmpty
            ? const Center(
                child: Text('No events yet'),
              )
            : EventsList(eventLogs: sorted);
        return Container(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Event log',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: Spacing.md),
                const EventLogListHeader(),
                const SizedBox(height: Spacing.md),
                Expanded(child: content),
              ],
            ));
      },
    );
  }
}
