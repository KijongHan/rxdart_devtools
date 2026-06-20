import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import 'src/state/events_controller.dart';
import 'src/state/streams_controller.dart';
import 'src/theme.dart';
import 'src/widgets/empty_state.dart';
import 'src/widgets/events_list.dart';
import 'src/widgets/stream_list.dart';

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

  @override
  void initState() {
    super.initState();
    _streamsController = StreamsController()..start();
    _eventsController = EventsController()..start();
  }

  @override
  void dispose() {
    _streamsController.dispose();
    _eventsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PanelTheme(
      child: ListenableBuilder(
        listenable: Listenable.merge([_streamsController, _eventsController]),
        builder: (context, _) {
          if (_streamsController.streams.isEmpty) {
            return const EmptyState();
          }
          return Row(
            children: [
              Expanded(
                child: StreamList(streams: _streamsController.streams),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: EventsList(eventLogs: _eventsController.eventLogs),
              ),
            ],
          );
        },
      ),
    );
  }
}
