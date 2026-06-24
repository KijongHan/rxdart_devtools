import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class InjectRequestDto {
  InjectRequestDto({required this.identifier, required this.raw});

  final String identifier;
  final String raw;

  factory InjectRequestDto.fromJson(Map<String, dynamic> json) =>
      _$InjectRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InjectRequestDtoToJson(this);
}

@JsonSerializable()
class InjectErrorRequestDto {
  InjectErrorRequestDto({required this.identifier, required this.message});

  final String identifier;
  final String message;

  factory InjectErrorRequestDto.fromJson(Map<String, dynamic> json) =>
      _$InjectErrorRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InjectErrorRequestDtoToJson(this);
}
