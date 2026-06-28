// ignore_for_file: public_member_api_docs

import 'package:result_dart/result_dart.dart';

typedef RegistryConfig = ({String name, int? historySize});

enum StreamIdentifierStrategy {
  uuid,
  name,
}

class SubjectInjector {
  SubjectInjector({required this.add, required this.addError});

  final Result<void> Function(String raw) add;
  final Result<void> Function(String message) addError;
}