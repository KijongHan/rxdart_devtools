import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/features/streams/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/components/status_dot.dart';

class StreamsList extends StatelessWidget {
  const StreamsList(
      {super.key,
      required this.viewState,
      required this.onSelectedStreamChanged});

  final StreamsViewState viewState;
  final void Function(String streamId) onSelectedStreamChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: viewState.streams.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final s = viewState.streams[index];
        return ListTile(
          key: ValueKey(s.id),
          dense: true,
          selected: s.id == viewState.selectedStreamId,
          onTap: () => onSelectedStreamChanged(s.id),
          leading: StatusDot.forStreamEntry(s),
          title: Text(s.name),
          subtitle: Text(s.typeLabel),
          trailing: Text(s.lastValue ?? '—'),
        );
      },
    );
  }
}
