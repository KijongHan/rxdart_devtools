// Builds the Flutter web panel and copies the output into the runtime
// package's extension/devtools/build/ directory.
//
// Run from the workspace root:
//
//   dart tool/build_panel.dart
//
// This wraps the official tooling. The same command can be invoked manually:
//
//   dart run devtools_extensions build_and_copy \
//     --source=packages/rxdart_devtools_extension \
//     --dest=packages/rxdart_devtools/extension/devtools

import 'dart:io';

Future<void> main(List<String> args) async {
  final result = await Process.start(
    'dart',
    [
      'run',
      'devtools_extensions',
      'build_and_copy',
      '--source=packages/rxdart_devtools_extension',
      '--dest=packages/rxdart_devtools/extension/devtools',
    ],
    mode: ProcessStartMode.inheritStdio,
    workingDirectory: Directory.current.path,
  );

  final exitCode = await result.exitCode;
  if (exitCode != 0) {
    stderr.writeln(
      'build_panel: devtools_extensions build_and_copy exited with $exitCode',
    );
    exit(exitCode);
  }

  stdout.writeln(
    'build_panel: panel built and copied into packages/rxdart_devtools/extension/devtools/build/',
  );
}
