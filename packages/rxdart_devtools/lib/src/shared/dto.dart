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
  SortRequestDto({
    required this.sortField,
    required this.sortDirection,
  });

  final SortField sortField;
  final SortDirection sortDirection;

  factory SortRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SortRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SortRequestDtoToJson(this);
}
