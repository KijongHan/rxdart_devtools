import 'package:rxdart_devtools/src/types/events.dart';

class Events {
  Events._();

  static final Events instance = Events._();

  final List<BaseEventLog<dynamic>> _eventLogs = [];
}
