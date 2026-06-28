import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

/// Request payload for the `ext.rxdart.inject` service extension —
/// pushes a raw text value into a tracked subject.
@JsonSerializable()
class InjectRequestDto {
  /// Creates an inject request targeting [identifier] with the raw text [raw].
  InjectRequestDto({required this.identifier, required this.raw});

  /// Identifier of the tracked subject to inject into.
  final String identifier;

  /// Raw text from the panel; the subject's `parse` callback turns this
  /// into the subject's value type.
  final String raw;

  /// Deserialises an [InjectRequestDto] from JSON.
  factory InjectRequestDto.fromJson(Map<String, dynamic> json) =>
      _$InjectRequestDtoFromJson(json);

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$InjectRequestDtoToJson(this);
}

/// Request payload for the `ext.rxdart.injectError` service extension —
/// pushes an error onto a tracked subject.
@JsonSerializable()
class InjectErrorRequestDto {
  /// Creates an inject-error request targeting [identifier] with [message].
  InjectErrorRequestDto({required this.identifier, required this.message});

  /// Identifier of the tracked subject to inject the error into.
  final String identifier;

  /// Error message that will be forwarded to `subject.addError(...)`.
  final String message;

  /// Deserialises an [InjectErrorRequestDto] from JSON.
  factory InjectErrorRequestDto.fromJson(Map<String, dynamic> json) =>
      _$InjectErrorRequestDtoFromJson(json);

  /// Serialises this DTO to JSON.
  Map<String, dynamic> toJson() => _$InjectErrorRequestDtoToJson(this);
}
