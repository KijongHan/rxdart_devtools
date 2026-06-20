import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import 'src/state/events_controller.dart';
import 'src/state/stream_events_controller.dart';
import 'src/state/streams_controller.dart';
import 'src/theme.dart';
import 'src/widgets/empty_state.dart';
import 'src/widgets/events_list.dart';
import 'src/widgets/stream_events_list.dart';
import 'src/widgets/streams_list.dart';

void main() {
  runApp(const RxDartDevToolsExtension());
}

class RxDartDevToolsExtension extends StatelessWidget {
  const RxDartDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(
      child: _Panel(),
    );
  }
}

class _Panel extends StatefulWidget {
  const _Panel();

  @override
  State<_Panel> createState() => _PanelState();
}

class _PanelState extends State<_Panel> {
  late final StreamsController _streamsController;
  late final EventsController _eventsController;
  late final StreamEventsController _streamEventsController;

  @override
  void initState() {
    super.initState();
    _streamsController = StreamsController()..start();
    _eventsController = EventsController()..start();
    _streamEventsController = StreamEventsController()..start();
  }

  @override
  void dispose() {
    _streamsController.dispose();
    _eventsController.dispose();
    _streamEventsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PanelTheme(
      child: ListenableBuilder(
        listenable: Listenable.merge([
          _streamsController,
          _eventsController,
          _streamEventsController,
        ]),
        builder: (context, _) {
          if (_streamsController.streams.isEmpty) {
            return const EmptyState();
          }
          final selectedStreamId = _streamEventsController.selectedStreamId;
          final selectedStream = selectedStreamId == null
              ? null
              : _streamsController.streams
                  .where((s) => s.id == selectedStreamId)
                  .firstOrNull;
          return Row(
            children: [
              Expanded(
                child: StreamsList(
                  streams: _streamsController.streams,
                  selectedStreamId: selectedStreamId,
                  onSelect: (stream) =>
                      _streamEventsController.selectStream(stream.id),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: StreamEventsList(
                  selectedStreamId: selectedStreamId,
                  selectedStream: selectedStream,
                  eventLogs: _streamEventsController.eventLogs,
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: EventsList(
                  eventLogs: _eventsController.eventLogs,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
