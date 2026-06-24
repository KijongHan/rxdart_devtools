final class DateTimeUtils {
  static String shortTimestamp(String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return iso;
    final h = parsed.hour.toString().padLeft(2, '0');
    final m = parsed.minute.toString().padLeft(2, '0');
    final s = parsed.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  static String fullTimestamp(String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return iso;
    return '$iso ${parsed.timeZoneName}';
  }
}
