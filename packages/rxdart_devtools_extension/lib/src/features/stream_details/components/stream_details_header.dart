import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';
import 'package:rxdart_devtools_extension/src/features/stream_details/components/detail_row.dart';
import 'package:rxdart_devtools_extension/src/shared/components/status_dot.dart';
import 'package:rxdart_devtools_extension/src/shared/utils.dart';

class StreamDetailsHeader extends StatelessWidget {
  const StreamDetailsHeader({super.key, required this.stream});

  final StreamEntryDto stream;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    StatusDot.forStreamEntry(stream),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stream.name, style: textTheme.titleMedium),
                        Text(
                          stream.typeLabel,
                          style: textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO(inject): open inject dialog and call the
                  // ext.rxdart.inject service extension via RegistryClient.
                },
                icon: const Icon(Icons.add, size: 8),
                label: const Text('Inject'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          DetailRow(label: 'ID', value: stream.id),
          DetailRow(label: 'Last value', value: stream.lastValue ?? '—'),
          DetailRow(
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
