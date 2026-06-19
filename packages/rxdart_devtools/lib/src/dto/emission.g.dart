// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireEmission _$WireEmissionFromJson(Map<String, dynamic> json) => WireEmission(
      value: json['value'] as String?,
      timestamp: json['timestamp'] as String,
      isError: json['isError'] as bool,
    );

Map<String, dynamic> _$WireEmissionToJson(WireEmission instance) =>
    <String, dynamic>{
      'value': instance.value,
      'timestamp': instance.timestamp,
      'isError': instance.isError,
    };
