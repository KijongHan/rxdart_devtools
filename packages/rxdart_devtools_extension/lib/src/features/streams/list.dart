import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/view_model.dart';
import 'package:rxdart_devtools_extension/src/features/streams/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/components/status_dot.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';

typedef _StreamsListViewState = ({
  List<StreamEntryDto> streams,
  String? selectedStreamId,
});

class StreamsList extends StatefulWidget {
  const StreamsList({super.key});

  @override
  State<StreamsList> createState() => _StreamsListState();
}

class _StreamsListState extends State<StreamsList> {
  late final StreamsViewModel _streamsViewModel;
  late final StreamDetailsViewModel _streamDetailsViewModel;
  late final Stream<_StreamsListViewState> _viewState;

  @override
  void initState() {
    super.initState();
    _streamsViewModel = getIt.get<StreamsViewModel>();
    _streamDetailsViewModel = getIt.get<StreamDetailsViewModel>();
    _viewState = Rx.combineLatest2(
      _streamsViewModel.streams,
      _streamDetailsViewModel.selectedStreamId,
      (streams, selectedStreamId) => (
        streams: streams,
        selectedStreamId: selectedStreamId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_StreamsListViewState>(
      stream: _viewState,
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
              onTap: () => _streamDetailsViewModel.selectStream(s.id),
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
