import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:theme_generator_x/theme_generator_x.dart';

const JsonDecoder _kDecoder = JsonDecoder();
final ColorsUtils colorUtils = ColorsUtils();

class ColorsCommand extends Command<void> {
  ColorsCommand() {
    argParser
      ..addOption(
        'colors_path',
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

    // color url
    if (argResults?['colors_path'] == null) {
      throw UsageException('Color path must be not null', 'Enter color file path');
    }
    final String colorPath = argResults?['colors_path'] as String;

    // output path
    if (argResults?['output'] == null) {
      throw UsageException('Output file path doesn"t exist', 'Use correct output file path');
    }
    final String outputPath = argResults?['output'] as String;

    final String absOutputPath = p.join(Directory.current.path, outputPath);
    Utils.printCyan('file path: $absOutputPath');
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

    final StringBuffer sb = StringBuffer('fsdfsdfsd'); // TODO

    // sb.writeln('''
    //     // GENERATED CODE - DO NOT MODIFY BY HAND

    //     // ignore_for_file: avoid_classes_with_only_static_members

    //     import 'package:uikit/uikit.dart';
    //     import 'package:flutter/material.dart';

    //     ''');

    // final String lightColor = _colorGenerator(colorContent.body, className: ColorUtils.lightColorClassName);
    // final String darkColor = _colorGenerator(
    //   colorContent.body,
    //   className: ColorUtils.darkColorClassName,
    //   useCustomDark: true,
    // ); // stub

    // // results
    // // final String resultBaseColor = colorUtils.resultBaseColorClass(_fieldNameMap);
    // // final String resultColor = colorUtils.resultColorClass(_fieldNameMap);
    // final String resultExtensionClass = colorUtils.resultColorExtensionClass(_fieldNameMap);
    // final String resultExtensionDataClass = colorUtils.resultColorExtensionDataClass(_fieldNameMap);

    // sb
    //   // ..writeln(resultBaseColor)
    //   ..writeln(lightColor)
    //   ..writeln(darkColor)
    //   ..writeln(resultExtensionClass)
    //   ..writeln(resultExtensionDataClass);

    outputFile.writeAsStringSync(sb.toString());
  }

  // String _colorGenerator(String content, {required String className, bool useCustomDark = false}) {
  //   final StringBuffer sb = StringBuffer();

  //   sb.writeln('''
  //     class $className {
  //   ''');

  //   final Map<String, dynamic> tokenMap = _kDecoder.convert(content) as Map<String, dynamic>;

  //   // key: "🄲 Brand[S100]"
  //   tokenMap.forEach((String key, dynamic value) {
  //     final PayloadResult payload = colorUtils.handleColor(key, value, useCustomDark: useCustomDark);

  //     _fieldNameMap.addAll(payload.fieldNameMap);

  //     sb.writeln(payload.content);
  //   });

  //   sb.writeln('}'); // close class

  //   return sb.toString();
  // }
}
