// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

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
      'listenerCount': instance.listenerCount,
      'lastEmittedAt': instance.lastEmittedAt,
      'isClosed': instance.isClosed,
      'closedAt': instance.closedAt,
    };

ListStreamEntriesResponseDto _$ListStreamEntriesResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ListStreamEntriesResponseDto(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => StreamEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListStreamEntriesResponseDtoToJson(
        ListStreamEntriesResponseDto instance) =>
    <String, dynamic>{
      'entries': instance.entries.map((e) => e.toJson()).toList(),
    };

StreamEventDto _$StreamEventDtoFromJson(Map<String, dynamic> json) =>
    StreamEventDto(
      streamId: json['streamId'] as String,
    );

Map<String, dynamic> _$StreamEventDtoToJson(StreamEventDto instance) =>
    <String, dynamic>{
      'streamId': instance.streamId,
    };

StreamUpdatedEventDto _$StreamUpdatedEventDtoFromJson(
        Map<String, dynamic> json) =>
    StreamUpdatedEventDto(
      streamId: json['streamId'] as String,
      entry: StreamEntryDto.fromJson(json['entry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StreamUpdatedEventDtoToJson(
        StreamUpdatedEventDto instance) =>
    <String, dynamic>{
      'streamId': instance.streamId,
      'entry': instance.entry.toJson(),
    };
