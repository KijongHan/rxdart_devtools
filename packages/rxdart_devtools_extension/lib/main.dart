import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import 'src/state/streams_controller.dart';
import 'src/theme.dart';
import 'src/widgets/empty_state.dart';
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
  late final StreamsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StreamsController()..start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PanelTheme(
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.streams.isEmpty) {
            return const EmptyState();
          }
          return StreamList(streams: _controller.streams);
        },
      ),
    );
  }
}
