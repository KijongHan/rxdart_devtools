import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart_devtools/src/types/streams.dart';

import 'emission.dart';

part 'snapshot.g.dart';

@JsonSerializable(explicitToJson: true)
class TrackedSnapshot {
  TrackedSnapshot({
    required this.id,
    required this.name,
    required this.typeLabel,
    required this.lastValue,
    required this.lastError,
    required this.emissionCount,
    required this.listenerCount,
    required this.lastEmittedAt,
    required this.isClosed,
    required this.closedAt,
  });

  factory TrackedSnapshot.fromEntry(StreamEntry<dynamic> entry) =>
      TrackedSnapshot(
        id: entry.entryIdentifier.id,
        name: entry.entryIdentifier.name,
        typeLabel: entry.entryIdentifier.typeLabel,
        lastValue: entry.data?.lastValue?.toString(),
        lastError: entry.data?.lastError?.toString(),
        emissionCount: entry.metadata.emissionCount,
        listenerCount: entry.metadata.listenerCount,
        lastEmittedAt: entry.metadata.lastEmittedAt?.toIso8601String(),
        isClosed: entry.metadata.isClosed,
        closedAt: entry.metadata.closedAt?.toIso8601String(),
      );

  factory TrackedSnapshot.fromJson(Map<String, dynamic> json) =>
      _$TrackedSnapshotFromJson(json);

  final String id;
  final String name;
  final String typeLabel;
  final String? lastValue;
  final String? lastError;
  final int emissionCount;
  final int listenerCount;
  final String? lastEmittedAt;
  final bool isClosed;
  final String? closedAt;

  Map<String, dynamic> toJson() => _$TrackedSnapshotToJson(this);
}
