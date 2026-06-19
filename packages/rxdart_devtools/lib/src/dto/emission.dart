import 'package:json_annotation/json_annotation.dart';
import 'package:rxdart_devtools/src/types/streams.dart';

part 'emission.g.dart';

@JsonSerializable()
class WireEmission {
  WireEmission({
    required this.value,
    required this.timestamp,
    required this.isError,
  });

  factory WireEmission.fromEmission(Emission<dynamic> emission) => WireEmission(
        value: emission.value?.toString(),
        timestamp: emission.timestamp.toIso8601String(),
        isError: emission.isError,
      );

  factory WireEmission.fromJson(Map<String, dynamic> json) =>
      _$WireEmissionFromJson(json);

  final String? value;
  final String timestamp;
  final bool isError;

  Map<String, dynamic> toJson() => _$WireEmissionToJson(this);
}
