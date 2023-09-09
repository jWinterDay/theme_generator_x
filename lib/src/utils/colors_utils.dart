import 'dart:convert';
import 'dart:io';
import 'package:theme_generator_x/theme_generator_x.dart';

const JsonDecoder _kDecoder = JsonDecoder();

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

    for (final MapEntry<String, dynamic> entry in tokenMap.entries) {
      final String key = Utils.rename(entry.key, to: keysRename);
      final dynamic value = entry.value;

      /// `1. simple string "#f6f4da"`
      if (value is String) {
        final String lightColorResult = replaceColorVal(value);

        break;
      }

      /// `2. map {"light": "#f6f4da"} or {"light": "#f6f4da", "dark": "#000011"}. Dark is optional`
      if (value is Map<String, dynamic>) {
        final dynamic rawLightValue = value['light'];
        final dynamic rawDarkValue = value['dark'];

        if (rawLightValue == null) {
          throw Exception('List light color is null. $key: $value');
        }

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
          throw Exception('List light map color is null. $key: $value');
        }

        if (rawLightValueList is List<dynamic>) {
          final List<String> resultLightColorList = rawLightValueList.map((dynamic element) {
            if (element is String) {
              final String colorResult = replaceColorVal(element);
            }

            throw Exception('Unknown list format. $key: $value');
          }).toList();
        }

        if (rawDarkValueList is List<dynamic>) {
          final List<String> resultDarkColorList = rawDarkValueList.map((dynamic element) {
            if (element is String) {
              final String colorResult = replaceColorVal(element);
            }

            throw Exception('Unknown list format. $key: $value');
          }).toList();
        }

        break;
      }

      throw Exception('Unknown color format $key: $value');
    }

    return sb.toString();
  }
  // static const String commonColorThemeXClassName = 'AppThemeDataColorsV2X';

  // static const String commonColorClassName = 'AppColorsV2';
  // static const String commonBaseColorClassName = '_BaseColor';

  // static const String lightColorClassName = '_L';
  // static const String darkColorClassName = '_D';

  /// ```json
  ///{
  ///  "🄲 Brand[S100]": {
  ///    "21|19.92": {
  ///      "value": "#050818"
  ///    },
  ///    "2|1.13": {
  ///      "value": "#e9f1ff"
  ///    }
  ///  }
  ///}```
  ///
  ///key: "🄲 Brand[S100]"
  // PayloadResult handleColor(String key, dynamic value, {bool useCustomDark = false}) {
  //   final StringBuffer sbForMap = StringBuffer();

  //   final Map<String, String> fieldNameMap = <String, String>{};

  //   final Map<String, dynamic> vals = value as Map<String, dynamic>;

  //   // subKey: "21|19.92"
  //   vals.forEach((String subKey, dynamic subValue) {
  //     final String fieldName = renameColorKey(key); // 🄲 Brand[S100] => BrandS100

  //     // sub
  //     final String fieldSubName = renameSubnameFieldKey(subKey);
  //     final Map<String, dynamic> subValMap = subValue as Map<String, dynamic>;

  //     final String rawColor = subValMap['value'].toString();
  //     final String subColorVal = replaceColorVal(rawColor);
  //     //
  //     final String resultFn = resultFieldName(fieldName: fieldName, fieldSubName: fieldSubName);

  //     fieldNameMap.putIfAbsent(resultFn, () => '$key ($subKey)');

  //     if (useCustomDark) {
  //       sbForMap.writeln(
  //         '''
  //       static final Color $resultFn = invertColor(const Color($subColorVal));
  //     ''',
  //       );
  //     } else {
  //       sbForMap.writeln(
  //         '''
  //       static const Color $resultFn = Color($subColorVal);
  //     ''',
  //       );
  //     }
  //   });

  //   return PayloadResult(
  //     fieldNameMap: fieldNameMap,
  //     content: sbForMap.toString(),
  //   );
  // }

  // String resultBaseColorClass(Map<String, String> fieldNameMap) {
  //   final StringBuffer sb = StringBuffer();

  //   sb.writeln('abstract class ${ColorUtils.commonBaseColorClassName} {');

  //   fieldNameMap.forEach((String fieldName, String rawJsonName) {
  //     /// $rawJsonName
  //     sb.write(
  //       '''
  //     Color get $fieldName;
  //     ''',
  //     );
  //   });

  //   sb.writeln('}'); // class

  //   return sb.toString();
  // }

  // @Deprecated('Use resultColorExtensionClass for creating ThemeExtension')

  // ///  🄲 Brand[S100] (0|1.03)
  // String resultColorClass(Map<String, String> fieldNameMap) {
  //   final StringBuffer sb = StringBuffer();

  //   sb.writeln(
  //     '''
  //   class ${ColorUtils.commonColorClassName} {
  //     ${ColorUtils.commonColorClassName}(this.br) {
  //       switch (br) {
  //         case Brightness.dark:
  //           _baseColor = _D();
  //           break;

  //         default:
  //           _baseColor = _L();
  //       }
  //     }

  //     final Brightness br;

  //     late ${ColorUtils.commonBaseColorClassName} _baseColor;
  // ''',
  //   );

  //   fieldNameMap.forEach((String fieldName, String rawJsonName) {
  //     sb.write(
  //       '''
  //     /// $rawJsonName
  //     Color get $fieldName => _baseColor.$fieldName;
  //     ''',
  //     );
  //   });

  //   sb.writeln('}'); // class

  //   return sb.toString();
  // }

  // String resultColorExtensionClass(Map<String, String> fieldNameMap) {
  //   final StringBuffer sb = StringBuffer();

  //   // 1 arguments
  //   final StringBuffer argSb = StringBuffer();
  //   fieldNameMap.forEach((String fieldName, String _) {
  //     argSb.write('required this.$fieldName,');
  //   });

  //   // 2 fields
  //   final StringBuffer fieldsSb = StringBuffer();
  //   fieldNameMap.forEach((String fieldName, String _) {
  //     fieldsSb.write('''
  //       final Color? $fieldName;
  //     ''');
  //   });

  //   // 3 copyWith arguments
  //   final StringBuffer copyWithArgSb = StringBuffer();
  //   fieldNameMap.forEach((String fieldName, String _) {
  //     copyWithArgSb.write('''
  //       Color? $fieldName,
  //     ''');
  //   });

  //   // 3 copyWith arguments
  //   final StringBuffer copyWithBodySb = StringBuffer();
  //   fieldNameMap.forEach((String fieldName, String _) {
  //     copyWithBodySb.write('''
  //       $fieldName: $fieldName ?? this.$fieldName,
  //     ''');
  //   });

  //   // 4 lerp body
  //   final StringBuffer lerpBodySb = StringBuffer();
  //   fieldNameMap.forEach((String fieldName, String _) {
  //     lerpBodySb.write('''
  //       $fieldName: Color.lerp($fieldName, other.$fieldName, t),
  //     ''');
  //   });

  //   sb.writeln(
  //     '''
  //     @immutable
  //     class ${ColorUtils.commonColorThemeXClassName} extends ThemeExtension<${ColorUtils.commonColorThemeXClassName}> {
  //       const ${ColorUtils.commonColorThemeXClassName}({
  //         $argSb
  //       });

  //       $fieldsSb

  //       @override
  //       ${ColorUtils.commonColorThemeXClassName} copyWith({
  //         $copyWithArgSb
  //       }) {
  //         return ${ColorUtils.commonColorThemeXClassName}(
  //           $copyWithBodySb
  //         );
  //       }

  //       @override
  //       ${ColorUtils.commonColorThemeXClassName} lerp(${ColorUtils.commonColorThemeXClassName}? other, double t) {
  //         if (other is! ${ColorUtils.commonColorThemeXClassName}) {
  //           return this;
  //         }

  //         return ${ColorUtils.commonColorThemeXClassName}(
  //           $lerpBodySb
  //         );
  //       }
  //     }
  //   ''',
  //   );

  //   return sb.toString();
  // }

  // String resultColorExtensionDataClass(Map<String, String> fieldNameMap) {
  //   final StringBuffer sb = StringBuffer();

  //   final StringBuffer bodySb = StringBuffer();
  //   fieldNameMap.forEach((String fieldName, String _) {
  //     bodySb.write('''
  //       $fieldName: isDark ?  ${ColorUtils.darkColorClassName}.$fieldName : ${ColorUtils.lightColorClassName}.$fieldName,
  //     ''');
  //   });

  //   sb.writeln('''
  //     ${ColorUtils.commonColorThemeXClassName} colorV2XData({required bool isDark}) {
  //       return AppThemeDataColorsV2X(
  //         $bodySb
  //       );
  //     }
  //   ''');

  //   return sb.toString();
  // }

  // /// 🄲 Brand[S100] => BrandS100
  // String renameColorKey(String key) {
  //   return key.replaceAll(RegExp(r'\[|\]|🄲|\s'), '');
  // }

  // /// 21|19.92
  // String renameSubnameFieldKey(String key) {
  //   return '_$key'.replaceAll(RegExp(r'\|'), '_').replaceAll(RegExp(r'\.'), ''); // 21|19.92
  // }

  // /// #495aa6 => 0xff495aa6
  // String replaceColorVal(String subColor) {
  //   if (!subColor.startsWith('#')) {
  //     return '0xffffffff'; // TODO(enikiforov): default color
  //   }

  //   if (subColor.length == 7) {
  //     return subColor.replaceAll(RegExp('#'), '0xff');
  //   }

  //   return subColor.replaceAll(RegExp('#'), '0x');
  // }

  // /// cBrandS100_0_103
  // String resultFieldName({required String fieldName, required String fieldSubName}) {
  //   final String fullTxt = '$fieldName$fieldSubName';

  //   return ReCase(fullTxt).camelCase;
  // }
}
