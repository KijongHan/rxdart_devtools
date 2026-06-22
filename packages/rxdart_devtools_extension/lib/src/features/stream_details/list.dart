import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';

import '../events/tile.dart';

class StreamEventsList extends StatelessWidget {
  const StreamEventsList({
    required this.selectedStreamId,
    required this.selectedStream,
    required this.eventLogs,
    super.key,
  });

  final String? selectedStreamId;
  final StreamEntryDto? selectedStream;
  final List<EventLogDto> eventLogs;

  @override
  Widget build(BuildContext context) {
    if (selectedStreamId == null) {
      return const Center(
        child: Text('Select a stream to view its events'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (selectedStream != null)
          _StreamDetails(stream: selectedStream!)
        else
          _MissingStream(streamId: selectedStreamId!),
        const Divider(height: 1),
        Expanded(
          child: eventLogs.isEmpty
              ? const Center(child: Text('No events for this stream'))
              : ListView.separated(
                  itemCount: eventLogs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = eventLogs[index];
                    return EventTile(key: ValueKey(log.id), log: log);
                  },
                ),
        ),
      ],
    );
  }
}

class _StreamDetails extends StatelessWidget {
  const _StreamDetails({required this.stream});

  final StreamEntryDto stream;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stream.name, style: textTheme.titleMedium),
          const SizedBox(height: 6),
          _DetailRow(label: 'ID', value: stream.id),
          _DetailRow(label: 'Last value', value: stream.lastValue ?? '—'),
          _DetailRow(
            label: 'Last updated',
            value: stream.lastEmittedAt == null
                ? '—'
                : shortTimestamp(stream.lastEmittedAt!),
          ),
        ],
      ),
    );
  }
}

class _MissingStream extends StatelessWidget {
  const _MissingStream({required this.streamId});

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
          _DetailRow(label: 'ID', value: streamId),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
