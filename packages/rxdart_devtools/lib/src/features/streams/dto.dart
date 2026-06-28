import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';
import 'package:rxdart_devtools/src/shared/utils.dart';

part 'dto.g.dart';

/// Snapshot of a tracked stream's current state — what the panel renders in
/// the **Current value** card.
@JsonSerializable(explicitToJson: true)
class StreamEntryDto {
  /// Creates a stream-entry snapshot. Prefer [StreamEntryDto.fromEntry].
  StreamEntryDto({
    required this.id,
    required this.name,
    required this.typeLabel,
    required this.lastValue,
    required this.lastError,
    required this.listenerCount,
    required this.lastEmittedAt,
    required this.isClosed,
    required this.closedAt,
    required this.isInjectable,
    required this.isSubject,
  });

  /// Builds a [StreamEntryDto] from an internal [StreamEntry].
  factory StreamEntryDto.fromEntry(StreamEntry<dynamic> entry) =>
      StreamEntryDto(
        id: entry.entryIdentifier.id,
        name: entry.entryIdentifier.name,
        typeLabel: entry.entryIdentifier.typeLabel,
        lastValue: Serialization.encodeValue(entry.data?.lastValue),
        lastError: entry.data?.lastError?.toString(),
        listenerCount: entry.metadata.listenerCount,
        lastEmittedAt: entry.metadata.lastEmittedAt?.toIso8601String(),
        isClosed: entry.metadata.isClosed,
        closedAt: entry.metadata.closedAt?.toIso8601String(),
        isInjectable: entry.metadata.isInjectable,
        isSubject: entry.metadata.isSubject,
      );

  /// Deserialises a [StreamEntryDto] from JSON.
  factory StreamEntryDto.fromJson(Map<String, dynamic> json) =>
      _$StreamEntryDtoFromJson(json);

  /// Stable identifier for the stream.
  final String id;

  /// Name the developer passed to `.track('name')`.
  final String name;

  /// Display string for the stream's value type (e.g. `int`, `User`).
  final String typeLabel;

  /// JSON-encoded form of the latest emitted value, or `null` if none yet.
  final String? lastValue;

  /// String form of the most recent error, or `null` if none.
  final String? lastError;

  /// Number of active listeners on the stream.
  final int listenerCount;

  /// ISO-8601 timestamp of the last emission, or `null` if none yet.
  final String? lastEmittedAt;

  /// Whether the stream has completed/closed.
  final bool isClosed;

  /// ISO-8601 timestamp of when the stream was closed, or `null` if open.
  final String? closedAt;

  /// Whether the tracked subject accepts panel-driven value injection.
  final bool isInjectable;

  /// Whether the tracked value is a rxdart `Subject` (vs. a plain `Stream`).
  final bool isSubject;

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$StreamEntryDtoToJson(this);
}

/// Response payload for the `ext.rxdart.listStreamEntries` service extension.
@JsonSerializable(explicitToJson: true)
class ListStreamEntriesResponseDto {
  /// Creates a response with the given list of [entries].
  ListStreamEntriesResponseDto({required this.entries});

  /// Snapshot for each currently-tracked stream.
  final List<StreamEntryDto> entries;

  /// Deserialises a [ListStreamEntriesResponseDto] from JSON.
  factory ListStreamEntriesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ListStreamEntriesResponseDtoFromJson(json);

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$ListStreamEntriesResponseDtoToJson(this);
}

/// Minimal payload identifying which stream emitted an event.
@JsonSerializable()
class StreamEventDto {
  /// Creates an event payload targeting [streamId].
  StreamEventDto({required this.streamId});

  /// Identifier of the stream the event applies to.
  final String streamId;

  /// Deserialises a [StreamEventDto] from JSON.
  factory StreamEventDto.fromJson(Map<String, dynamic> json) =>
      _$StreamEventDtoFromJson(json);

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$StreamEventDtoToJson(this);
}

/// Event payload pushed when a tracked stream's snapshot changes.
@JsonSerializable(explicitToJson: true)
class StreamUpdatedEventDto {
  /// Creates an update event for [streamId] with the new [entry] snapshot.
  StreamUpdatedEventDto({required this.streamId, required this.entry});

  /// Identifier of the stream that updated.
  final String streamId;

  /// New snapshot of the stream's state.
  final StreamEntryDto entry;

  /// Deserialises a [StreamUpdatedEventDto] from JSON.
  factory StreamUpdatedEventDto.fromJson(Map<String, dynamic> json) =>
      _$StreamUpdatedEventDtoFromJson(json);

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$StreamUpdatedEventDtoToJson(this);
}
