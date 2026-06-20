import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart_devtools/src/types/streams.dart';

part 'stream_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class StreamEntryDto {
  StreamEntryDto({
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
  });

  factory StreamEntryDto.fromEntry(StreamEntry<dynamic> entry) =>
      StreamEntryDto(
        id: entry.entryIdentifier.id,
        name: entry.entryIdentifier.name,
        typeLabel: entry.entryIdentifier.typeLabel,
        lastValue: entry.data?.lastValue?.toString(),
        lastError: entry.data?.lastError?.toString(),
        emissionCount: entry.metadata.emissionCount,
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
  final int emissionCount;
  final int listenerCount;
  final String? lastEmittedAt;
  final bool isClosed;
  final String? closedAt;

  Map<String, dynamic> toJson() => _$StreamEntryDtoToJson(this);
}
