typedef RegistryConfig = ({String name, int? historySize});

enum StreamIdentifierStrategy {
  uuid,
  name,
}

class SubjectInjector {
  SubjectInjector({required this.add, required this.addError});

  final void Function(String raw) add;
  final void Function(String message) addError;
}
