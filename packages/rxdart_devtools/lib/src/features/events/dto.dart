import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart_devtools/src/features/events/types.dart';

part 'dto.g.dart';

sealed class EventLogDto {
  const EventLogDto({
    required this.id,
    required this.timestamp,
    required this.streamId,
  });

  final String id;
  final String timestamp;
  final String streamId;

  factory EventLogDto.fromEventLog(BaseEventLog log) => switch (log) {
        ChangeEventLog<dynamic>() => ChangeEventLogDto.fromEventLog(log),
        ErrorEventLog() => ErrorEventLogDto.fromEventLog(log),
        RegisterEventLog() => RegisterEventLogDto.fromEventLog(log),
        DeregisterEventLog() => DeregisterEventLogDto.fromEventLog(log),
      };

  factory EventLogDto.fromJson(Map<String, dynamic> json) =>
      switch (json['type']) {
        'change' => ChangeEventLogDto.fromJson(json),
        'error' => ErrorEventLogDto.fromJson(json),
        'register' => RegisterEventLogDto.fromJson(json),
        'deregister' => DeregisterEventLogDto.fromJson(json),
        final type => throw FormatException(
            'Unknown EventLogDto type: $type',
          ),
      };

  Map<String, dynamic> toJson();
}

@JsonSerializable()
final class ChangeEventLogDto extends EventLogDto {
  ChangeEventLogDto({
    required super.id,
    required super.timestamp,
    required super.streamId,
    required this.newValue,
    required this.oldValue,
  });

  factory ChangeEventLogDto.fromEventLog(ChangeEventLog<dynamic> log) =>
      ChangeEventLogDto(
        id: log.eventLogIdentifier.id,
        timestamp: log.eventLogIdentifier.timestamp.toIso8601String(),
        streamId: log.streamIdentifier.id,
        newValue: log.newValue?.toString(),
        oldValue: log.oldValue?.toString(),
      );

  factory ChangeEventLogDto.fromJson(Map<String, dynamic> json) =>
      _$ChangeEventLogDtoFromJson(json);

  final String? newValue;
  final String? oldValue;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'change',
        ..._$ChangeEventLogDtoToJson(this),
      };
}

@JsonSerializable()
final class ErrorEventLogDto extends EventLogDto {
  ErrorEventLogDto({
    required super.id,
    required super.timestamp,
    required super.streamId,
    required this.error,
  });

  factory ErrorEventLogDto.fromEventLog(ErrorEventLog log) => ErrorEventLogDto(
        id: log.eventLogIdentifier.id,
        timestamp: log.eventLogIdentifier.timestamp.toIso8601String(),
        streamId: log.streamIdentifier.id,
        error: log.error.toString(),
      );

  factory ErrorEventLogDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorEventLogDtoFromJson(json);

  final String error;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'error',
        ..._$ErrorEventLogDtoToJson(this),
      };
}

@JsonSerializable()
final class RegisterEventLogDto extends EventLogDto {
  RegisterEventLogDto({
    required super.id,
    required super.timestamp,
    required super.streamId,
  });

  factory RegisterEventLogDto.fromEventLog(RegisterEventLog log) =>
      RegisterEventLogDto(
        id: log.eventLogIdentifier.id,
        timestamp: log.eventLogIdentifier.timestamp.toIso8601String(),
        streamId: log.streamIdentifier.id,
      );

  factory RegisterEventLogDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterEventLogDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'register',
        ..._$RegisterEventLogDtoToJson(this),
      };
}

@JsonSerializable()
final class DeregisterEventLogDto extends EventLogDto {
  DeregisterEventLogDto({
    required super.id,
    required super.timestamp,
    required super.streamId,
  });

  factory DeregisterEventLogDto.fromEventLog(DeregisterEventLog log) =>
      DeregisterEventLogDto(
        id: log.eventLogIdentifier.id,
        timestamp: log.eventLogIdentifier.timestamp.toIso8601String(),
        streamId: log.streamIdentifier.id,
      );

  factory DeregisterEventLogDto.fromJson(Map<String, dynamic> json) =>
      _$DeregisterEventLogDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'deregister',
        ..._$DeregisterEventLogDtoToJson(this),
      };
}

@JsonSerializable()
class ListStreamEventLogsRequestDto {
  ListStreamEventLogsRequestDto({required this.streamId});

  final String streamId;

  factory ListStreamEventLogsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ListStreamEventLogsRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ListStreamEventLogsRequestDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ListEventLogsResponseDto {
  ListEventLogsResponseDto({required this.eventLogs});

  final List<EventLogDto> eventLogs;

  factory ListEventLogsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ListEventLogsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ListEventLogsResponseDtoToJson(this);
}

@JsonSerializable()
final class EventLogAddedEventDto {
  EventLogAddedEventDto({required this.streamId, required this.eventLog});

  final String streamId;
  final EventLogDto eventLog;

  factory EventLogAddedEventDto.fromJson(Map<String, dynamic> json) =>
      _$EventLogAddedEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventLogAddedEventDtoToJson(this);
}
