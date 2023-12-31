import 'dart:convert';
import 'package:theme_generator_x/theme_generator_x.dart';

const JsonDecoder _kDecoder = JsonDecoder();

const String _kExtensionTemplate = '''
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

const String _kExtensionDataTemplate = '''
#ClassName# #DataMethodName# () {
  return const #ClassName#(
    #Values
  );
}
''';

class ColorsUtils {
  static const String _darkName = 'dark';
  static const String _lightName = 'light';

  /// #495aa6 => 0xff495aa6
  String replaceColorVal(String? color) {
    if (color == null) {
      throw Exception('color is null');
    }

    // 0xff9e9e9e
    // #495aa6 len = 7
    // #ff495aa6 len = 9
    if (!<int>[7, 9, 10].contains(color.length)) {
      throw Exception('Color [$color] does not have required format: #495aa6 or #ff495aa6');
    }

    // 0xff9e9e9e
    if (color.length == 10 && color.startsWith('0x')) {
      return 'Color($color)';
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
  String generateX({
    required String content,
    required String className,
    required bool useDark,
    required String keysRename,
  }) {
    final StringBuffer sb = StringBuffer();

    sb.writeln('''
      // GENERATED CODE - DO NOT MODIFY BY HAND

      import 'package:flutter/material.dart';
    ''');

    final Map<String, dynamic> tokenMap = _kDecoder.convert(content) as Map<String, dynamic>;

    // result class
    final StringBuffer extParams = StringBuffer();
    final StringBuffer extFields = StringBuffer();
    final StringBuffer extCopyWithArguments = StringBuffer();
    final StringBuffer extCopyWithReturn = StringBuffer();
    final StringBuffer extLerpReturn = StringBuffer();

    // result data
    final StringBuffer dataLightValues = StringBuffer();
    final StringBuffer dataDarkValues = StringBuffer();

    // _kExtensionDataTemplate

    for (final MapEntry<String, dynamic> entry in tokenMap.entries) {
      final String keyResultName = Utils.rename(entry.key, to: keysRename);
      final dynamic value = entry.value;

      //
      extParams.writeln('required this.$keyResultName,');
      extCopyWithReturn.writeln('$keyResultName: $keyResultName ?? this.$keyResultName,');

      switch (value) {
        /// `1. simple string "#f6f4da"`
        case final String lVal:
          final String lightColorResult = replaceColorVal(lVal);
          // class
          extFields.writeln('final Color? $keyResultName;');
          extCopyWithArguments.writeln('Color? $keyResultName,');
          extLerpReturn.writeln('$keyResultName: Color.lerp($keyResultName, other.$keyResultName, t),');
          // data
          dataLightValues.writeln('$keyResultName: $lightColorResult,');
          if (useDark) {
            dataDarkValues.writeln('$keyResultName: $lightColorResult,');
          }

        /// `2. map {"light": "#f6f4da"} or {"light": "#f6f4da", "dark": "#000011"}`
        case {_lightName: final String lVal}:
          final String? dVal = value[_darkName];
          final String lightColorResult = replaceColorVal(lVal);
          final String darkColorResult = dVal == null ? lightColorResult : replaceColorVal(dVal);

          // class
          extFields.writeln('final Color? $keyResultName;');
          extCopyWithArguments.writeln('Color? $keyResultName,');
          extLerpReturn.writeln('$keyResultName: Color.lerp($keyResultName, other.$keyResultName, t),');
          // data
          dataLightValues.writeln('$keyResultName: $lightColorResult,');
          if (useDark) {
            dataDarkValues.writeln('$keyResultName: $darkColorResult,'); //
          }

        /// `3. map of array colors {"light": ["#656213", "#000011"], "dark": ["#656213", "#000011"]}. Dark is optional`
        case {_lightName: final dynamic lVal}:
          // light
          List<String> lightList = <String>[];
          if (lVal is List<dynamic>) {
            lightList = lVal.map((dynamic element) => replaceColorVal(element?.toString())).toList();
          }
          final String resultLigthStr = '''
            <Color>[
              ${lightList.join(',')},
            ]
          ''';

          // dark
          List<String>? darkList;
          String? resultDarkStr;
          if (useDark) {
            final dynamic dValRaw = value[_darkName];
            if (dValRaw is List<dynamic>) {
              darkList = dValRaw.map((dynamic element) => replaceColorVal(element?.toString())).toList();
            }
            resultDarkStr = darkList == null
                ? resultLigthStr
                : '''
                <Color>[
                  ${darkList.join(',')},
                ]
              ''';
          }

          // class
          extFields.writeln('final List<Color>? $keyResultName;');
          extCopyWithArguments.writeln('List<Color>? $keyResultName,');
          extLerpReturn.writeln('$keyResultName: $keyResultName,');
          // data
          dataLightValues.writeln('$keyResultName: $resultLigthStr,');
          if (useDark) {
            dataDarkValues.writeln('$keyResultName: $resultDarkStr,'); //
          }

        /// `4. list of strings ["#f6f4da", "0xff9e9e9e"]`
        case final List<dynamic> lVal: // final String lVal:

          final String lightColorResult = replaceColorVal(lVal[0].toString());

          // class
          extFields.writeln('final Color? $keyResultName;');
          extCopyWithArguments.writeln('Color? $keyResultName,');
          extLerpReturn.writeln('$keyResultName: Color.lerp($keyResultName, other.$keyResultName, t),');

          // data
          dataLightValues.writeln('$keyResultName: $lightColorResult,');
          if (useDark) {
            if (lVal.length != 2) {
              throw Exception('Unknown list of colors format $keyResultName: $entry');
            }

            final String darkColorResult = replaceColorVal(lVal[1]);

            dataDarkValues.writeln('$keyResultName: $darkColorResult,');
          }

        default:
          throw Exception('Unknown color format $keyResultName: $entry');
      }
    }

    // replace in template
    final String resultClassTemplate = _kExtensionTemplate
        .replaceAll(RegExp('#ClassName#'), className) // AppThemeDataColorsX
        .replaceAll(RegExp('#Params#'), extParams.toString())
        .replaceAll(RegExp('#Fields#'), extFields.toString())
        .replaceAll(RegExp('#CopyWithArguments#'), extCopyWithArguments.toString())
        .replaceAll(RegExp('#CopyWithReturn#'), extCopyWithReturn.toString())
        .replaceAll(RegExp('#LerpReturn#'), extLerpReturn.toString());

    final String resultLightDataTemplate = _kExtensionDataTemplate
        .replaceAll(RegExp('#ClassName#'), className) // AppThemeDataColorsX
        .replaceAll(RegExp('#DataMethodName#'), '$_lightName${className}Data') // ligthAppThemeDataColorsXData
        .replaceAll(RegExp('#Values'), dataLightValues.toString());

    String? resultDarkDataTemplate;
    if (useDark) {
      resultDarkDataTemplate = _kExtensionDataTemplate
          .replaceAll(RegExp('#ClassName#'), className) // AppThemeDataColorsX
          .replaceAll(RegExp('#DataMethodName#'), '$_darkName${className}Data') // darkAppThemeDataColorsXData
          .replaceAll(RegExp('#Values'), dataDarkValues.toString());
    }

    sb
      ..writeln(resultLightDataTemplate)
      ..writeln('\n')
      ..writeln(resultDarkDataTemplate ?? '')
      ..writeln('\n\n')
      ..writeln(resultClassTemplate);

    return sb.toString();
  }
}
