import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/view_model.dart';
import 'package:rxdart_devtools_extension/src/shared/components/status_dot.dart';
import 'package:rxdart_devtools_extension/src/shared/providers.dart';
import 'package:rxdart_devtools_extension/src/shared/utils.dart';

import '../events/components/event_log_tile.dart';

class StreamEventsList extends StatefulWidget {
  const StreamEventsList({super.key});

  @override
  State<StreamEventsList> createState() => _StreamEventsListState();
}

class _StreamEventsListState extends State<StreamEventsList> {
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.selectedStream != null)
              _StreamDetails(stream: state.selectedStream!)
            else
              _MissingStream(streamId: state.selectedStreamId!),
            const Divider(height: 1),
            Expanded(
              child: state.eventLogs.isEmpty
                  ? const Center(child: Text('No events for this stream'))
                  : ListView.separated(
                      itemCount: state.eventLogs.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final log = state.eventLogs[index];
                        return EventLogTile(
                          key: ValueKey(log.id),
                          log: log,
                          showStreamName: false,
                        );
                      },
                    ),
            ),
          ],
        );
      },
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
          Row(
            children: [
              StatusDot.forStreamEntry(stream),
              const SizedBox(width: 8),
              Flexible(
                child: Text(stream.name, style: textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _DetailRow(label: 'ID', value: stream.id),
          _DetailRow(label: 'Last value', value: stream.lastValue ?? '—'),
          _DetailRow(
            label: 'Last updated',
            value: stream.lastEmittedAt == null
                ? '—'
                : DateTimeUtils.shortTimestamp(stream.lastEmittedAt!),
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
