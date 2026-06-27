import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/components/missing_stream_header.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/components/selected_stream_event_logs.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/components/stream_details_header.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/constants.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class StreamDetailsPanel extends StatefulWidget {
  const StreamDetailsPanel({super.key});

  @override
  State<StreamDetailsPanel> createState() => _StreamDetailsPanelState();
}

class _StreamDetailsPanelState extends State<StreamDetailsPanel> {
  late final StreamDetailsViewModel _streamDetailsViewModel;

  @override
  void initState() {
    super.initState();
    _streamDetailsViewModel = getIt.get<StreamDetailsViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StreamDetailsViewState>(
      stream: _streamDetailsViewModel.viewState,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) return const SizedBox.shrink();
        if (state.selectedStreamId == null) {
          return const Center(
            child: Text('Select a stream to view its events'),
          );
        }
        return Container(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Stream details',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.md),
              if (state.selectedStream != null)
                StreamDetailsHeader(stream: state.selectedStream!)
              else
                MissingStreamHeader(streamId: state.selectedStreamId!),
              const SizedBox(height: Spacing.md),
              const Divider(height: 1),
              Expanded(
                child: SelectedStreamEventLogs(eventLogs: state.eventLogs),
              ),
            ],
          ),
        );
      },
    );
  }
}
