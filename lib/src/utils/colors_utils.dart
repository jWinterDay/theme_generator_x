import 'package:recase/recase.dart';

class ColorsUtils {
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
