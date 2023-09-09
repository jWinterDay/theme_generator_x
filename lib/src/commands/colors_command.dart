import 'dart:io';

import 'package:args/command_runner.dart';
// import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:theme_generator_x/theme_generator_x.dart';

class ColorsCommand extends Command<void> {
  ColorsCommand() {
    argParser
      ..addOption(
        'input',
        abbr: 'p',
        help: 'colors path',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'output file path',
      )
      ..addOption(
        'class_name',
        abbr: 'c',
        help: 'output class name',
      )
      ..addOption(
        'keys_rename',
        abbr: 'r',
        allowed: <String>[
          'camel_case', // camelCase
          'original',
          'snake_case', // snake_case
        ],
        defaultsTo: 'camel_case',
      );
  }

  @override
  String get description => 'theme generator x. colors';

  @override
  String get name => 'colors';

  @override
  String get invocation => '${runner?.executableName} $name [arguments] <directories>';

  // final Map<String, String> _fieldNameMap = <String, String>{};

  @override
  Future<void> run() async {
    Utils.printGreen('$name generator');

    // input path
    if (argResults?['input'] == null) {
      throw UsageException('Input file path must be not null', 'Enter color file path');
    }
    final String inputPath = argResults?['input'] as String;
    final String absInputPath = p.join(Directory.current.path, inputPath);
    Utils.printCyan('file input path: $absInputPath');
    final File inputFile = File(absInputPath);
    final bool inputExists = inputFile.existsSync();
    if (!inputExists) {
      throw UsageException('Input file does not exist', 'Ensure input file exists');
    }

    // output path
    if (argResults?['output'] == null) {
      throw UsageException('Output file path does not exist', 'Use correct output file path');
    }
    final String outputPath = argResults?['output'] as String;

    final String absOutputPath = p.join(Directory.current.path, outputPath);
    Utils.printCyan('file output path: $absOutputPath');
    final File outputFile = File(absOutputPath);
    final bool outputExists = outputFile.existsSync();
    if (!outputExists) {
      outputFile.createSync();
    }

    // class name
    if (argResults?['class_name'] == null) {
      throw UsageException('Color extension class name must be not null', 'Enter extension class name');
    }
    final String className = argResults?['class_name'] as String;

    final String keysRename = argResults?['keys_rename'] as String;

    // download files
    // final http.Response colorContent = await http.get(Uri.parse(colorPath));
    // if (colorContent.statusCode != 200) {
    //   throw UsageException(
    //     'Can not download color content ${colorContent.statusCode}',
    //     'Can not download color content',
    //   );
    // }

    // print(' colorContent.body = ${colorContent.body}');

    // final http.Response colorDarkContent = await http.get(Uri.parse(colorDarkUrl));
    // if (colorDarkContent.statusCode != 200) {
    //   throw UsageException(
    //     'Can not download color content ${colorDarkContent.statusCode}',
    //     'Can not download dark color content',
    //   );
    // }

    // generate
    // final StringBuffer sb = StringBuffer();
    // sb.writeln('// keysRename = $keysRename');
    // sb.writeln('// className = $className');
    // sb.writeln('// outputPath = $outputPath');
    // sb.writeln('// absOutputPath = $absOutputPath');

    //
    final ColorsUtils colorUtils = ColorsUtils();

    final String result = colorUtils.generateX(inputFile: inputFile, className: className, keysRename: keysRename);

    outputFile.writeAsStringSync(result);
  }
}
