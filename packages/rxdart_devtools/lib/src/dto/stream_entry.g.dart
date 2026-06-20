// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamEntryDto _$StreamEntryDtoFromJson(Map<String, dynamic> json) =>
    StreamEntryDto(
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
    );

Map<String, dynamic> _$StreamEntryDtoToJson(StreamEntryDto instance) =>
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
    };
