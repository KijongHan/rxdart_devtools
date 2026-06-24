import 'package:flutter/material.dart';
import 'package:rxdart_devtools/dto.dart';

class StatusDot extends StatelessWidget {
  const StatusDot({required this.color, this.size = 10, super.key});

  factory StatusDot.forStreamEntry(
    StreamEntryDto entry, {
    double size = 10,
  }) =>
      StatusDot(color: _colorFor(entry), size: size);

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

Color _colorFor(StreamEntryDto entry) {
  if (entry.isClosed) return Colors.grey;
  if (entry.lastError != null) return Colors.red;
  return Colors.green;
}
