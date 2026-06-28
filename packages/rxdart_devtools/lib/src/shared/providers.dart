// ignore_for_file: public_member_api_docs

import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

final getIt = GetIt.instance;

final class DateTimeProvider {
  DateTime now() => DateTime.now();
}

final class UuidProvider {
  final Uuid _uuid = Uuid();

  String generate() => _uuid.v4();
}