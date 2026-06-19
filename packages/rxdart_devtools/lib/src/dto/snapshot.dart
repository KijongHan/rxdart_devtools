import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart_devtools/src/services/types.dart';

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
    required this.history,
  });

  factory TrackedSnapshot.fromEntry(TrackedEntry<dynamic> entry) =>
      TrackedSnapshot(
        id: entry.id,
        name: entry.name,
        typeLabel: entry.typeLabel,
        lastValue: entry.lastValue?.toString(),
        lastError: entry.lastError?.toString(),
        emissionCount: entry.emissionCount,
        listenerCount: entry.listenerCount,
        lastEmittedAt: entry.lastEmittedAt?.toIso8601String(),
        isClosed: entry.isClosed,
        closedAt: entry.closedAt?.toIso8601String(),
        history: entry.history.map(WireEmission.fromEmission).toList(),
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
  final List<WireEmission> history;

  Map<String, dynamic> toJson() => _$TrackedSnapshotToJson(this);
}
