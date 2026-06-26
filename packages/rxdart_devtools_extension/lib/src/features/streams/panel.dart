import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/repository.dart';
import 'package:rxdart_devtools_extension/src/features/streams/components/list.dart';
import 'package:rxdart_devtools_extension/src/features/streams/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class StreamsPanel extends StatefulWidget {
  const StreamsPanel({super.key});

  @override
  State<StreamsPanel> createState() => _StreamsPanelState();
}

class _StreamsPanelState extends State<StreamsPanel> {
  late final StreamsViewModel _streamsViewModel;
  late final StreamDetailsRepository _streamDetailsRepository;

  @override
  void initState() {
    super.initState();
    _streamsViewModel = getIt.get<StreamsViewModel>();
    _streamDetailsRepository = getIt.get<StreamDetailsRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StreamsViewState>(
      stream: _streamsViewModel.viewState,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Streams',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamsList(
                viewState: state,
                onSelectedStreamChanged: (streamId) =>
                    _streamDetailsRepository.selectStream(streamId),
              ),
            ),
          ],
        );
      },
    );
  }
}
