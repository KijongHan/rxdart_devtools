import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/client.dart';
import 'package:rxdart_devtools_extension/src/features/events/view_model.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/view_model.dart';
import 'package:rxdart_devtools_extension/src/features/streams/client.dart';
import 'package:rxdart_devtools_extension/src/features/streams/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

import 'src/features/events/list.dart';
import 'src/features/stream_details/list.dart';
import 'src/features/streams/empty_state.dart';
import 'src/features/streams/list.dart';
import 'src/theme.dart';

void main() {
  runApp(const RxDartDevToolsExtension());
}

class RxDartDevToolsExtension extends StatefulWidget {
  const RxDartDevToolsExtension();

  @override
  State<RxDartDevToolsExtension> createState() =>
      RxDartDevToolsExtensionState();
}

class RxDartDevToolsExtensionState extends State<RxDartDevToolsExtension> {
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
  late final StreamsViewModel _streamsViewModel;
  late final EventsViewModel _eventsViewModel;

  @override
  void initState() {
    super.initState();
    getIt.registerSingleton(VmServiceProvider());

    getIt.registerSingleton(StreamsClient());
    getIt.registerSingleton(EventsClient());

    getIt.registerSingleton(EventsViewModel());
    getIt.registerSingleton(StreamsViewModel());
    getIt.registerSingleton(StreamDetailsViewModel());

    _streamsViewModel = getIt.get<StreamsViewModel>();
    _eventsViewModel = getIt.get<EventsViewModel>();
    _streamsViewModel.refresh();
    _eventsViewModel.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return PanelTheme(
      child: StreamBuilder<List<StreamEntryDto>>(
        stream: _streamsViewModel.streams,
        builder: (context, snapshot) {
          final streams = snapshot.data;
          if (streams == null || streams.isEmpty) {
            return const EmptyState();
          }
          return const Row(
            children: [
              Expanded(child: StreamsList()),
              VerticalDivider(width: 1),
              Expanded(child: StreamEventsList()),
              VerticalDivider(width: 1),
              Expanded(child: EventsList()),
            ],
          );
        },
      ),
    );
  }
}
