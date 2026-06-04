import 'package:flutter/material.dart';
import 'package:rxdart_devtools/wire.dart';

class StreamList extends StatelessWidget {
  const StreamList({required this.streams, super.key});

  final List<TrackedSnapshot> streams;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: streams.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final s = streams[index];
        return ListTile(
          dense: true,
          title: Text(s.name),
          subtitle: Text('${s.typeLabel} · ${s.emissionCount} emissions'),
          trailing: Text(s.lastValue ?? '—'),
        );
      },
    );
  }
}
