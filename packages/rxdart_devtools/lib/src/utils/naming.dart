import '../devtools/init.dart';

abstract final class Naming {
  static int _fallbackCounter = 0;

  static String fromStackTrace(String typeLabel, RxDartDevtoolsConfig config) {
    if (!config.captureStackTraces) {
      return '$typeLabel#${_fallbackCounter++}';
    }
    final frame = _firstUserFrame(StackTrace.current);
    if (frame == null) return '$typeLabel#${_fallbackCounter++}';
    return '$frame · $typeLabel';
  }

  static String? _firstUserFrame(StackTrace trace) {
    final lines = trace.toString().split('\n');
    for (final line in lines) {
      final match = RegExp(r'\(([^)\s]+\.dart):(\d+)').firstMatch(line);
      if (match == null) continue;
      final file = match.group(1)!.split('/').last;
      if (file.startsWith('track.dart') ||
          file.startsWith('registry.dart') ||
          file.startsWith('naming.dart')) {
        continue;
      }
      return '$file:${match.group(2)}';
    }
    return null;
  }
}
