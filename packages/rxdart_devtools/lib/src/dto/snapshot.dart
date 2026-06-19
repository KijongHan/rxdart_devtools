import 'emission.dart';
import 'package:rxdart_devtools/src/services/types.dart';

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

  factory TrackedSnapshot.fromEntry(TrackedEntry entry) => TrackedSnapshot(
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

  factory TrackedSnapshot.fromJson(Map<String, Object?> json) =>
      TrackedSnapshot(
        id: json['id']! as String,
        name: json['name']! as String,
        typeLabel: json['typeLabel']! as String,
        lastValue: json['lastValue'] as String?,
        lastError: json['lastError'] as String?,
        emissionCount: json['emissionCount']! as int,
        listenerCount: json['listenerCount']! as int,
        lastEmittedAt: json['lastEmittedAt'] as String?,
        isClosed: json['isClosed']! as bool,
        closedAt: json['closedAt'] as String?,
        history: (json['history']! as List)
            .cast<Map<String, Object?>>()
            .map(WireEmission.fromJson)
            .toList(),
      );

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

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'typeLabel': typeLabel,
        'lastValue': lastValue,
        'lastError': lastError,
        'emissionCount': emissionCount,
        'listenerCount': listenerCount,
        'lastEmittedAt': lastEmittedAt,
        'isClosed': isClosed,
        'closedAt': closedAt,
        'history': history.map((e) => e.toJson()).toList(),
      };
}
