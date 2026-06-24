import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/events/client.dart';
import 'package:rxdart_devtools_extension/src/features/events/components/event_log_list.dart';
import 'package:rxdart_devtools_extension/src/features/events/view_model.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/panel.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/repository.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/view_model.dart';
import 'package:rxdart_devtools_extension/src/features/streams/client.dart';
import 'package:rxdart_devtools_extension/src/features/streams/repository.dart';
import 'package:rxdart_devtools_extension/src/shared/components/empty_state.dart';
import 'package:rxdart_devtools_extension/src/features/streams/list.dart';
import 'package:rxdart_devtools_extension/src/features/streams/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:rxdart_devtools_extension/src/theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamsRepository _streamsRepository;
  late final StreamDetailsRepository _streamDetailsRepository;

  @override
  void initState() {
    super.initState();
    getIt.registerSingleton(VmServiceProvider());

    getIt.registerSingleton(StreamsClient());
    getIt.registerSingleton(EventsClient());

    getIt.registerSingleton(StreamsRepository());
    getIt.registerSingleton(StreamDetailsRepository());

    getIt.registerSingleton(EventsViewModel());
    getIt.registerSingleton(StreamsViewModel());
    getIt.registerSingleton(StreamDetailsViewModel());

    _streamsRepository = getIt.get<StreamsRepository>();
    _streamDetailsRepository = getIt.get<StreamDetailsRepository>();
    _streamsRepository.refresh();
    _streamDetailsRepository.refresh();
  }

  @override
  void dispose() {
    _streamsRepository.dispose();
    _streamDetailsRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      child: StreamBuilder<List<StreamEntryDto>>(
        stream: _streamsRepository.streams,
        builder: (context, snapshot) {
          final streams = snapshot.data;
          if (streams == null || streams.isEmpty) {
            return const EmptyState();
          }
          return const _ResponsiveAppLayout();
        },
      ),
    );
  }
}

class _ResponsiveAppLayout extends StatelessWidget {
  const _ResponsiveAppLayout();

  static const _wideBreakpoint = 800.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _wideBreakpoint) {
          return const Row(
            children: [
              Expanded(child: StreamsList()),
              VerticalDivider(width: 1),
              Expanded(child: StreamDetailsPanel()),
              VerticalDivider(width: 1),
              Expanded(child: EventsList()),
            ],
          );
        }
        return const Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: StreamsList()),
                  VerticalDivider(width: 1),
                  Expanded(child: StreamDetailsPanel()),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(child: EventsList()),
          ],
        );
      },
    );
  }
}
