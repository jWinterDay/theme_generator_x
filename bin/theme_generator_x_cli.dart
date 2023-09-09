import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:theme_generator_x/theme_generator_x.dart';

Future<void> main(List<String> args) async {
  try {
    final CommandRunner<void> runner = CommandRunner<void>('theme_generator_x', 'theme_generator_x cli')
      ..addCommand(ColorsCommand());
    // ..addCommand(TextTypographyCommand());

    await runner.run(args);
  } on UsageException catch (exc) {
    stderr.writeln('$exc');
    exit(64);
  } on Exception catch (exc) {
    stderr.writeln('Unexpected error: $exc');
    exit(1);
  }
}
