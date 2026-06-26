import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

enum SortDirection {
  ascending,
  descending;

  factory SortDirection.fromJson(String json) => values.byName(json);
}

enum SortField {
  timestamp,
  streamId,
  lastUpdated;
}

@JsonSerializable()
class SortRequestDto {
  SortRequestDto({this.sortField, this.sortDirection});

  final SortField? sortField;
  final SortDirection? sortDirection;

  factory SortRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SortRequestDtoFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$SortRequestDtoToJson(this);
    json.removeWhere((_, value) => value == null);
    return json;
  }
}

@JsonSerializable()
class OkResponseDto {
  OkResponseDto({required this.ok});

  final bool ok;

  factory OkResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OkResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OkResponseDtoToJson(this);
}
