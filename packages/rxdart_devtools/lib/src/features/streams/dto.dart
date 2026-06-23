import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart_devtools/src/features/streams/types.dart';

part 'dto.g.dart';

@JsonSerializable(explicitToJson: true)
class StreamEntryDto {
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
  });

  factory StreamEntryDto.fromEntry(StreamEntry<dynamic> entry) =>
      StreamEntryDto(
        id: entry.entryIdentifier.id,
        name: entry.entryIdentifier.name,
        typeLabel: entry.entryIdentifier.typeLabel,
        lastValue: entry.data?.lastValue?.toString(),
        lastError: entry.data?.lastError?.toString(),
        listenerCount: entry.metadata.listenerCount,
        lastEmittedAt: entry.metadata.lastEmittedAt?.toIso8601String(),
        isClosed: entry.metadata.isClosed,
        closedAt: entry.metadata.closedAt?.toIso8601String(),
      );

  factory StreamEntryDto.fromJson(Map<String, dynamic> json) =>
      _$StreamEntryDtoFromJson(json);

  final String id;
  final String name;
  final String typeLabel;
  final String? lastValue;
  final String? lastError;
  final int listenerCount;
  final String? lastEmittedAt;
  final bool isClosed;
  final String? closedAt;

  Map<String, dynamic> toJson() => _$StreamEntryDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ListStreamEntriesResponseDto {
  ListStreamEntriesResponseDto({required this.entries});

  final List<StreamEntryDto> entries;

  factory ListStreamEntriesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ListStreamEntriesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ListStreamEntriesResponseDtoToJson(this);
}

@JsonSerializable()
class StreamEventDto {
  StreamEventDto({required this.streamId});

  final String streamId;

  factory StreamEventDto.fromJson(Map<String, dynamic> json) =>
      _$StreamEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StreamEventDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StreamUpdatedEventDto {
  StreamUpdatedEventDto({required this.streamId, required this.entry});

  final String streamId;
  final StreamEntryDto entry;

  factory StreamUpdatedEventDto.fromJson(Map<String, dynamic> json) =>
      _$StreamUpdatedEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StreamUpdatedEventDtoToJson(this);
}
