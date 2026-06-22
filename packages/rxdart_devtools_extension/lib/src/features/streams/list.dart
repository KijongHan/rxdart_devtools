import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';

class StreamsList extends StatelessWidget {
  const StreamsList({
    required this.streams,
    this.onSelect,
    this.selectedStreamId,
    super.key,
  });

  final List<StreamEntryDto> streams;
  final ValueChanged<StreamEntryDto>? onSelect;
  final String? selectedStreamId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: streams.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final s = streams[index];
        return ListTile(
          key: ValueKey(s.id),
          dense: true,
          selected: s.id == selectedStreamId,
          onTap: onSelect == null ? null : () => onSelect!(s),
          title: Text(s.name),
          subtitle: Text(s.typeLabel),
          trailing: Text(s.lastValue ?? '—'),
        );
      },
    );
  }
}
