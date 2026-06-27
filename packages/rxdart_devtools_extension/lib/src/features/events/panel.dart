import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/components/event_log_list.dart';
import 'package:rxdart_devtools_extension/src/features/events/components/event_log_list_header.dart';
import 'package:rxdart_devtools_extension/src/features/events/repository.dart';
import 'package:rxdart_devtools_extension/src/features/events/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:rxdart_devtools_extension/src/shared/spacing.dart';

class EventsPanel extends StatefulWidget {
  const EventsPanel({super.key});

  @override
  State<EventsPanel> createState() => _EventsPanelState();
}

class _EventsPanelState extends State<EventsPanel> {
  late final EventsRepository _eventsRepository;
  late final EventsViewModel _eventsViewModel;

  @override
  void initState() {
    super.initState();
    _eventsRepository = getIt.get<EventsRepository>();
    _eventsViewModel = getIt.get<EventsViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventLogDto>>(
      stream: _eventsViewModel.filteredEventLogs,
      builder: (context, snapshot) {
        final eventLogs = snapshot.data ?? const [];
        final content = eventLogs.isEmpty
            ? const Center(
                child: Text('No events yet'),
              )
            : EventsList(eventLogs: eventLogs);
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
                EventLogListHeader(
                  onSort: (sortField, sortDirection) => _eventsRepository.sort(
                      sortField: sortField, sortDirection: sortDirection,),
                  onSearch: (query) => _eventsViewModel.setSearchQuery(query),
                ),
                const SizedBox(height: Spacing.md),
                Expanded(child: content),
              ],
            ),);
      },
    );
  }
}
