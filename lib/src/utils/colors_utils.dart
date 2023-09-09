import 'dart:convert';
import 'dart:io';
import 'package:theme_generator_x/theme_generator_x.dart';

const JsonDecoder _kDecoder = JsonDecoder();

const String kExtensionTemplate = '''
@immutable
class #ClassName# extends ThemeExtension<#ClassName#> {
  const #ClassName# ({
    #Params#
  });

  #Fields#

  @override
  #ClassName# copyWith({
    #CopyWithArguments#
  }) {
    return #ClassName#(
      #CopyWithReturn#
    );
  }

  @override
  #ClassName# lerp(#ClassName#? other, double t) {
    if (other is! #ClassName#) {
      return this;
    }

    return #ClassName#(
      #LerpReturn#
    );
  }
}
''';

class ColorsUtils {
  /// #495aa6 => 0xff495aa6
  String replaceColorVal(String? color) {
    if (color == null) {
      throw Exception('color is null');
    }

    // #495aa6 len = 7
    // #ff495aa6 len = 9
    if (!<int>[7, 9].contains(color.length)) {
      throw Exception('Color [$color] does not have required format: #495aa6 or #ff495aa6');
    }

    if (!color.startsWith('#')) {
      throw Exception('Color [$color] does not start with #');
      // return '0xffffffff';
    }

    // #495aa6
    if (color.length == 7) {
      final String val = color.replaceAll(RegExp('#'), '0xff');
      return 'Color($val)';
    }

    // #ff495aa6
    final String val = color.replaceAll(RegExp('#'), '0x');
    return 'Color($val)';
  }

  /// ```json
  /// {
  ///     "primary": "#f6f4da",
  ///     "secondary": "#656213",
  ///     "some_color": "#000011",
  ///     "test_color": {
  ///         "dark": "#656213",
  ///         "light": "#000011"
  ///     },
  ///     "storyLinearGradientBackground": {
  ///         "dark": [
  ///             "#656213",
  ///             "#000011"
  ///         ],
  ///         "light": [
  ///             "#656213",
  ///             "#000011"
  ///         ]
  ///     }
  /// }
  /// ```
  String generateX({required File inputFile, required String className, required String keysRename}) {
    final StringBuffer sb = StringBuffer();

    sb.writeln('''
      // GENERATED CODE - DO NOT MODIFY BY HAND

      import 'package:flutter/material.dart';
    ''');

    final String content = inputFile.readAsStringSync();

    final Map<String, dynamic> tokenMap = _kDecoder.convert(content) as Map<String, dynamic>;

    // result strings
    final StringBuffer extParams = StringBuffer();
    final StringBuffer extFields = StringBuffer();
    final StringBuffer extCopyWithArguments = StringBuffer();
    final StringBuffer extCopyWithReturn = StringBuffer();
    final StringBuffer extLerpReturn = StringBuffer();
    //

    for (final MapEntry<String, dynamic> entry in tokenMap.entries) {
      final String keyResultName = Utils.rename(entry.key, to: keysRename);
      final dynamic value = entry.value;

      // ++++
      extParams.writeln('required this.$keyResultName,');
      extCopyWithReturn.writeln('$keyResultName: $keyResultName ?? this.$keyResultName,');
      // ++++

      /// `1. simple string "#f6f4da"`
      if (value is String) {
        final String lightColorResult = replaceColorVal(value);

        extFields.writeln('final Color? $keyResultName;');
        extCopyWithArguments.writeln('Color? $keyResultName,');
        extLerpReturn.writeln('$keyResultName: Color.lerp($keyResultName, other.$keyResultName, t),');

        break;
      }

      /// `2. map {"light": "#f6f4da"} or {"light": "#f6f4da", "dark": "#000011"}. Dark is optional`
      if (value is Map<String, dynamic>) {
        final dynamic rawLightValue = value['light'];
        final dynamic rawDarkValue = value['dark'];

        if (rawLightValue == null) {
          throw Exception('List light color is null. $keyResultName: $value');
        }

        extFields.writeln('final Color? $keyResultName;');
        extCopyWithArguments.writeln('Color? $keyResultName,');
        extLerpReturn.writeln('$keyResultName: Color.lerp($keyResultName, other.$keyResultName, t),');

        if (rawLightValue is String) {
          final String lightColorResult = replaceColorVal(rawLightValue);
        }

        if (rawDarkValue is String) {
          final String darkColorResult = replaceColorVal(rawDarkValue);
        }

        break;
      }

      /// `3. map of array colors {"light": ["#656213", "#000011"], "dark": ["#656213", "#000011"]}. Dark is optional`
      if (value is Map<String, dynamic>) {
        final dynamic rawLightValueList = value['light'];
        final dynamic rawDarkValueList = value['dark'];

        if (rawLightValueList == null) {
          throw Exception('List light map color is null. $keyResultName: $value');
        }

        extFields.writeln('final List<Color>? $keyResultName;');
        extCopyWithArguments.writeln('List<Color>? $keyResultName,');
        extLerpReturn.writeln('$keyResultName: $keyResultName,');

        if (rawLightValueList is List<dynamic>) {
          final List<String> resultLightColorList = rawLightValueList.map((dynamic element) {
            if (element is String) {
              return replaceColorVal(element);
            }

            throw Exception('Unknown list format. $keyResultName: $value');
          }).toList();
        }

        if (rawDarkValueList is List<dynamic>) {
          final List<String> resultDarkColorList = rawDarkValueList.map((dynamic element) {
            if (element is String) {
              return replaceColorVal(element);
            }

            throw Exception('Unknown list format. $keyResultName: $value');
          }).toList();
        }

        break;
      }

      throw Exception('Unknown color format $keyResultName: $value');
    }

    // replace in template
    kExtensionTemplate
      ..replaceAll('#ClassName#', className)
      ..replaceAll('#Params#', extParams.toString())
      ..replaceAll('#Fields#', extFields.toString())
      ..replaceAll('#CopyWithArguments#', extCopyWithArguments.toString())
      ..replaceAll('#CopyWithReturn#', extCopyWithReturn.toString())
      ..replaceAll('#LerpReturn#', extLerpReturn.toString());

    return sb.toString();
  }
}
