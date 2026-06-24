import 'package:flutter/material.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/components/detail_row.dart';

class MissingStreamHeader extends StatelessWidget {
  const MissingStreamHeader({super.key, required this.streamId});

  final String streamId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stream not found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          DetailRow(label: 'ID', value: streamId),
        ],
      ),
    );
  }
}
