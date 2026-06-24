import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/repository.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/view_model.dart';
import 'package:rxdart_devtools_extension/src/features/streams/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/components/status_dot.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

class StreamsList extends StatefulWidget {
  const StreamsList({super.key});

  @override
  State<StreamsList> createState() => _StreamsListState();
}

class _StreamsListState extends State<StreamsList> {
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
        return ListView.separated(
          itemCount: state.streams.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final s = state.streams[index];
            return ListTile(
              key: ValueKey(s.id),
              dense: true,
              selected: s.id == state.selectedStreamId,
              onTap: () => _streamDetailsRepository.selectStream(s.id),
              leading: StatusDot.forStreamEntry(s),
              title: Text(s.name),
              subtitle: Text(s.typeLabel),
              trailing: Text(s.lastValue ?? '—'),
            );
          },
        );
      },
    );
  }
}
