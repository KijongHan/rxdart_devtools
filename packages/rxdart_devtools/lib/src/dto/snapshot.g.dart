// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackedSnapshot _$TrackedSnapshotFromJson(Map<String, dynamic> json) =>
    TrackedSnapshot(
      id: json['id'] as String,
      name: json['name'] as String,
      typeLabel: json['typeLabel'] as String,
      lastValue: json['lastValue'] as String?,
      lastError: json['lastError'] as String?,
      emissionCount: (json['emissionCount'] as num).toInt(),
      listenerCount: (json['listenerCount'] as num).toInt(),
      lastEmittedAt: json['lastEmittedAt'] as String?,
      isClosed: json['isClosed'] as bool,
      closedAt: json['closedAt'] as String?,
      history: (json['history'] as List<dynamic>)
          .map((e) => WireEmission.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrackedSnapshotToJson(TrackedSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'typeLabel': instance.typeLabel,
      'lastValue': instance.lastValue,
      'lastError': instance.lastError,
      'emissionCount': instance.emissionCount,
      'listenerCount': instance.listenerCount,
      'lastEmittedAt': instance.lastEmittedAt,
      'isClosed': instance.isClosed,
      'closedAt': instance.closedAt,
      'history': instance.history.map((e) => e.toJson()).toList(),
    };
