import 'dart:convert';
import 'dart:io';
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
          dataDarkValues.writeln('$keyResultName: $lightColorResult,'); //

        /// `2. map {"light": "#f6f4da"} or {"light": "#f6f4da", "dark": "#000011"}`
        case {'light': final String lVal}:
          final String? dVal = value['dark'];
          final String lightColorResult = replaceColorVal(lVal);
          final String darkColorResult = dVal == null ? lightColorResult : replaceColorVal(dVal);

          // class
          extFields.writeln('final Color? $keyResultName;');
          extCopyWithArguments.writeln('Color? $keyResultName,');
          extLerpReturn.writeln('$keyResultName: Color.lerp($keyResultName, other.$keyResultName, t),');
          // data
          dataLightValues.writeln('$keyResultName: $lightColorResult,');
          dataDarkValues.writeln('$keyResultName: $darkColorResult,'); //

        /// `3. map of array colors {"light": ["#656213", "#000011"], "dark": ["#656213", "#000011"]}. Dark is optional`
        case {'light': final dynamic lVal}:
          // light
          List<String> lightList = <String>[];
          if (lVal is List<dynamic>) {
            lightList = lVal.map((dynamic element) => replaceColorVal(element?.toString())).toList();
          }
          final String resultLigthStr = '''
            <Color>[
              ${lightList.join(',')}
            ]
          ''';

          // dark
          final dynamic dValRaw = value['dark'];
          List<String>? darkList;
          if (dValRaw is List<dynamic>) {
            darkList = dValRaw.map((dynamic element) => replaceColorVal(element?.toString())).toList();
          }
          final String resultDarkStr = darkList == null
              ? resultLigthStr
              : '''
                <Color>[
                  ${darkList.join(',')}
                ]
              ''';

          // class
          extFields.writeln('final List<Color>? $keyResultName;');
          extCopyWithArguments.writeln('List<Color>? $keyResultName,');
          extLerpReturn.writeln('$keyResultName: $keyResultName,');
          // data
          dataLightValues.writeln('$keyResultName: $resultLigthStr,');
          dataDarkValues.writeln('$keyResultName: $resultDarkStr,'); //

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
        .replaceAll(RegExp('#DataMethodName#'), 'light${className}Data') // ligthAppThemeDataColorsXData
        .replaceAll(RegExp('#Values'), dataLightValues.toString());

    final String resultDarkDataTemplate = _kExtensionDataTemplate
        .replaceAll(RegExp('#ClassName#'), className) // AppThemeDataColorsX
        .replaceAll(RegExp('#DataMethodName#'), 'dark${className}Data') // darkAppThemeDataColorsXData
        .replaceAll(RegExp('#Values'), dataDarkValues.toString());

    sb
      ..writeln(resultLightDataTemplate)
      ..writeln('\n')
      ..writeln(resultDarkDataTemplate)
      ..writeln('\n\n')
      ..writeln(resultClassTemplate);

    return sb.toString();
  }
}
