// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeEventLogDto _$ChangeEventLogDtoFromJson(Map<String, dynamic> json) =>
    ChangeEventLogDto(
      id: json['id'] as String,
      timestamp: json['timestamp'] as String,
      streamId: json['streamId'] as String,
      newValue: json['newValue'] as String?,
      oldValue: json['oldValue'] as String?,
    );

Map<String, dynamic> _$ChangeEventLogDtoToJson(ChangeEventLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'streamId': instance.streamId,
      'newValue': instance.newValue,
      'oldValue': instance.oldValue,
    };

ErrorEventLogDto _$ErrorEventLogDtoFromJson(Map<String, dynamic> json) =>
    ErrorEventLogDto(
      id: json['id'] as String,
      timestamp: json['timestamp'] as String,
      streamId: json['streamId'] as String,
      error: json['error'] as String,
    );

Map<String, dynamic> _$ErrorEventLogDtoToJson(ErrorEventLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'streamId': instance.streamId,
      'error': instance.error,
    };

RegisterEventLogDto _$RegisterEventLogDtoFromJson(Map<String, dynamic> json) =>
    RegisterEventLogDto(
      id: json['id'] as String,
      timestamp: json['timestamp'] as String,
      streamId: json['streamId'] as String,
    );

Map<String, dynamic> _$RegisterEventLogDtoToJson(
        RegisterEventLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'streamId': instance.streamId,
    };

DeregisterEventLogDto _$DeregisterEventLogDtoFromJson(
        Map<String, dynamic> json) =>
    DeregisterEventLogDto(
      id: json['id'] as String,
      timestamp: json['timestamp'] as String,
      streamId: json['streamId'] as String,
    );

Map<String, dynamic> _$DeregisterEventLogDtoToJson(
        DeregisterEventLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'streamId': instance.streamId,
    };

ListEventLogsRequestDto _$ListEventLogsRequestDtoFromJson(
        Map<String, dynamic> json) =>
    ListEventLogsRequestDto(
      streamId: json['streamId'] as String?,
    );

Map<String, dynamic> _$ListEventLogsRequestDtoToJson(
        ListEventLogsRequestDto instance) =>
    <String, dynamic>{
      'streamId': instance.streamId,
    };

ListEventLogsResponseDto _$ListEventLogsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ListEventLogsResponseDto(
      eventLogs: (json['eventLogs'] as List<dynamic>)
          .map((e) => EventLogDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListEventLogsResponseDtoToJson(
        ListEventLogsResponseDto instance) =>
    <String, dynamic>{
      'eventLogs': instance.eventLogs.map((e) => e.toJson()).toList(),
    };

EventLogAddedEventDto _$EventLogAddedEventDtoFromJson(
        Map<String, dynamic> json) =>
    EventLogAddedEventDto(
      streamId: json['streamId'] as String,
      eventLog: EventLogDto.fromJson(json['eventLog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventLogAddedEventDtoToJson(
        EventLogAddedEventDto instance) =>
    <String, dynamic>{
      'streamId': instance.streamId,
      'eventLog': instance.eventLog,
    };
