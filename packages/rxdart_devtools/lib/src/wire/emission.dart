import '../registry.dart';

class WireEmission {
  WireEmission({required this.value, required this.timestamp, required this.isError});

  factory WireEmission.fromEmission(Emission emission) => WireEmission(
        value: emission.value?.toString(),
        timestamp: emission.timestamp.toIso8601String(),
        isError: emission.isError,
      );

  factory WireEmission.fromJson(Map<String, Object?> json) => WireEmission(
        value: json['value'] as String?,
        timestamp: json['timestamp']! as String,
        isError: json['isError']! as bool,
      );

  final String? value;
  final String timestamp;
  final bool isError;

  Map<String, Object?> toJson() => {
        'value': value,
        'timestamp': timestamp,
        'isError': isError,
      };
}
