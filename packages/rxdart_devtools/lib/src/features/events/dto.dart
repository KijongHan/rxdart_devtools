import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart_devtools/src/features/events/types.dart';
import 'package:rxdart_devtools/src/shared/utils.dart';

part 'dto.g.dart';

/// Base type for every event-log entry. Use the [fromJson] factory or pattern
/// match on the concrete subtypes ([ChangeEventLogDto], [ErrorEventLogDto],
/// [RegisterEventLogDto], [DeregisterEventLogDto]).
sealed class EventLogDto {
  /// Common base constructor for event-log entries.
  const EventLogDto({
    required this.id,
    required this.timestamp,
    required this.streamId,
  });

  /// Stable identifier for this event-log entry.
  final String id;

  /// ISO-8601 timestamp of when the event occurred.
  final String timestamp;

  /// Identifier of the stream the event belongs to.
  final String streamId;

  /// Builds the appropriate [EventLogDto] subtype from an internal
  /// [BaseEventLog].
  factory EventLogDto.fromEventLog(BaseEventLog log) => switch (log) {
        ChangeEventLog<dynamic>() => ChangeEventLogDto.fromEventLog(log),
        ErrorEventLog() => ErrorEventLogDto.fromEventLog(log),
        RegisterEventLog() => RegisterEventLogDto.fromEventLog(log),
        DeregisterEventLog() => DeregisterEventLogDto.fromEventLog(log),
      };

  /// Parses an [EventLogDto] from JSON, dispatching on the `type` field.
  /// Throws [FormatException] when `type` is unknown.
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

  /// Serialises this DTO to JSON. Subclasses tag the output with a `type`
  /// discriminator field so [fromJson] can route to the right factory.
  Map<String, dynamic> toJson();
}

/// Event-log entry recording a value emission (`subject.add(...)`).
@JsonSerializable()
final class ChangeEventLogDto extends EventLogDto {
  /// Creates a change event-log entry.
  ChangeEventLogDto({
    required super.id,
    required super.timestamp,
    required super.streamId,
    required this.newValue,
    required this.oldValue,
  });

  /// Builds a [ChangeEventLogDto] from an internal [ChangeEventLog].
  factory ChangeEventLogDto.fromEventLog(ChangeEventLog<dynamic> log) =>
      ChangeEventLogDto(
        id: log.eventLogIdentifier.id,
        timestamp: log.eventLogIdentifier.timestamp.toIso8601String(),
        streamId: log.streamIdentifier.id,
        newValue: Serialization.encodeValue(log.newValue),
        oldValue: Serialization.encodeValue(log.oldValue),
      );

  /// Deserialises a [ChangeEventLogDto] from JSON.
  factory ChangeEventLogDto.fromJson(Map<String, dynamic> json) =>
      _$ChangeEventLogDtoFromJson(json);

  /// JSON-encoded form of the newly emitted value.
  final String? newValue;

  /// JSON-encoded form of the previously emitted value, or `null` if this
  /// was the first emission.
  final String? oldValue;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'change',
        ..._$ChangeEventLogDtoToJson(this),
      };
}

/// Event-log entry recording an error emission (`subject.addError(...)`).
@JsonSerializable()
final class ErrorEventLogDto extends EventLogDto {
  /// Creates an error event-log entry.
  ErrorEventLogDto({
    required super.id,
    required super.timestamp,
    required super.streamId,
    required this.error,
  });

  /// Builds an [ErrorEventLogDto] from an internal [ErrorEventLog].
  factory ErrorEventLogDto.fromEventLog(ErrorEventLog log) => ErrorEventLogDto(
        id: log.eventLogIdentifier.id,
        timestamp: log.eventLogIdentifier.timestamp.toIso8601String(),
        streamId: log.streamIdentifier.id,
        error: log.error.toString(),
      );

  /// Deserialises an [ErrorEventLogDto] from JSON.
  factory ErrorEventLogDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorEventLogDtoFromJson(json);

  /// String form of the emitted error.
  final String error;

  @override
  Map<String, dynamic> toJson() => {
        'type': 'error',
        ..._$ErrorEventLogDtoToJson(this),
      };
}

/// Event-log entry recording that a stream was registered with the runtime.
@JsonSerializable()
final class RegisterEventLogDto extends EventLogDto {
  /// Creates a register event-log entry.
  RegisterEventLogDto({
    required super.id,
    required super.timestamp,
    required super.streamId,
  });

  /// Builds a [RegisterEventLogDto] from an internal [RegisterEventLog].
  factory RegisterEventLogDto.fromEventLog(RegisterEventLog log) =>
      RegisterEventLogDto(
        id: log.eventLogIdentifier.id,
        timestamp: log.eventLogIdentifier.timestamp.toIso8601String(),
        streamId: log.streamIdentifier.id,
      );

  /// Deserialises a [RegisterEventLogDto] from JSON.
  factory RegisterEventLogDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterEventLogDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'register',
        ..._$RegisterEventLogDtoToJson(this),
      };
}

/// Event-log entry recording that a tracked stream completed / closed.
@JsonSerializable()
final class DeregisterEventLogDto extends EventLogDto {
  /// Creates a deregister event-log entry.
  DeregisterEventLogDto({
    required super.id,
    required super.timestamp,
    required super.streamId,
  });

  /// Builds a [DeregisterEventLogDto] from an internal [DeregisterEventLog].
  factory DeregisterEventLogDto.fromEventLog(DeregisterEventLog log) =>
      DeregisterEventLogDto(
        id: log.eventLogIdentifier.id,
        timestamp: log.eventLogIdentifier.timestamp.toIso8601String(),
        streamId: log.streamIdentifier.id,
      );

  /// Deserialises a [DeregisterEventLogDto] from JSON.
  factory DeregisterEventLogDto.fromJson(Map<String, dynamic> json) =>
      _$DeregisterEventLogDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'type': 'deregister',
        ..._$DeregisterEventLogDtoToJson(this),
      };
}

/// Request payload for the `ext.rxdart.listEventLogs` service extension.
@JsonSerializable()
class ListEventLogsRequestDto {
  /// Creates a list-event-logs request. Pass [streamId] to filter to a single
  /// stream, or leave it `null` to fetch all event logs.
  ListEventLogsRequestDto({this.streamId});

  /// Optional filter — only return event logs for this stream identifier.
  final String? streamId;

  /// Deserialises a [ListEventLogsRequestDto] from JSON.
  factory ListEventLogsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ListEventLogsRequestDtoFromJson(json);

  /// Serialises this DTO to JSON, stripping `null` entries so the VM-side
  /// handler (which coerces to `Map<String, String>`) doesn't choke.
  Map<String, dynamic> toJson() {
    final json = _$ListEventLogsRequestDtoToJson(this);
    json.removeWhere((_, value) => value == null);
    return json;
  }
}

/// Response payload for the `ext.rxdart.listEventLogs` service extension.
@JsonSerializable(explicitToJson: true)
class ListEventLogsResponseDto {
  /// Creates a response with the given list of [eventLogs].
  ListEventLogsResponseDto({required this.eventLogs});

  /// Event-log entries that matched the request.
  final List<EventLogDto> eventLogs;

  /// Deserialises a [ListEventLogsResponseDto] from JSON.
  factory ListEventLogsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ListEventLogsResponseDtoFromJson(json);

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$ListEventLogsResponseDtoToJson(this);
}

/// Event payload pushed when a new event-log entry is recorded.
@JsonSerializable()
final class EventLogAddedEventDto {
  /// Creates an event-added payload for [streamId] carrying [eventLog].
  EventLogAddedEventDto({required this.streamId, required this.eventLog});

  /// Identifier of the stream the new event belongs to.
  final String streamId;

  /// The new event-log entry.
  final EventLogDto eventLog;

  /// Deserialises an [EventLogAddedEventDto] from JSON.
  factory EventLogAddedEventDto.fromJson(Map<String, dynamic> json) =>
      _$EventLogAddedEventDtoFromJson(json);

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$EventLogAddedEventDtoToJson(this);
}
