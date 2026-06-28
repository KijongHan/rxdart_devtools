import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

/// Sort order for paginated lists.
enum SortDirection {
  /// Lowest value first.
  ascending,

  /// Highest value first.
  descending;

  /// Parses a [SortDirection] from its JSON string representation.
  factory SortDirection.fromJson(String json) => values.byName(json);
}

/// Field a list can be sorted by.
enum SortField {
  /// Sort by the event's timestamp.
  timestamp,

  /// Sort by the stream's identifier.
  streamId,

  /// Sort by the stream's most-recent-update time.
  lastUpdated;
}

/// Optional sort parameters carried inside a request DTO.
@JsonSerializable()
class SortRequestDto {
  /// Creates a sort request. Both fields are optional — when absent the
  /// server uses its own default ordering.
  SortRequestDto({this.sortField, this.sortDirection});

  /// The field to sort by, or `null` for server-default.
  final SortField? sortField;

  /// The direction to sort in, or `null` for server-default.
  final SortDirection? sortDirection;

  /// Deserialises a [SortRequestDto] from JSON.
  factory SortRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SortRequestDtoFromJson(json);

  /// Serialises this DTO to JSON, stripping `null` entries so the VM-side
  /// handler (which coerces to `Map<String, String>`) doesn't choke.
  Map<String, dynamic> toJson() {
    final json = _$SortRequestDtoToJson(this);
    json.removeWhere((_, value) => value == null);
    return json;
  }
}

/// Generic "operation succeeded" response.
@JsonSerializable()
class OkResponseDto {
  /// Creates a response DTO with the given success flag.
  OkResponseDto({required this.ok});

  /// Whether the operation succeeded.
  final bool ok;

  /// Deserialises an [OkResponseDto] from JSON.
  factory OkResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OkResponseDtoFromJson(json);

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$OkResponseDtoToJson(this);
}
