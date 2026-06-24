// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InjectRequestDto _$InjectRequestDtoFromJson(Map<String, dynamic> json) =>
    InjectRequestDto(
      identifier: json['identifier'] as String,
      raw: json['raw'] as String,
    );

Map<String, dynamic> _$InjectRequestDtoToJson(InjectRequestDto instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'raw': instance.raw,
    };

InjectErrorRequestDto _$InjectErrorRequestDtoFromJson(
        Map<String, dynamic> json) =>
    InjectErrorRequestDto(
      identifier: json['identifier'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$InjectErrorRequestDtoToJson(
        InjectErrorRequestDto instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'message': instance.message,
    };
