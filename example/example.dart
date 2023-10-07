// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';

AppThemeDataColorsX lightAppThemeDataColorsXData() {
  return const AppThemeDataColorsX(
    primary: Color(0xfff6f4da),
    secondary: Color(0xff9e9e9e),
    someColor: Color(0xff000011),
    testColorSimple: Color(0xff000011),
    testColor: Color(0xff000011),
    simpleMapOfArray: <Color>[
      Color(0xff656213),
      Color(0xff000011),
    ],
    simpleMapOfArrayDark: <Color>[
      Color(0xff995577),
      Color(0xff000011),
    ],
    composite: Color(0xfff6f4da),
  );
}

AppThemeDataColorsX darkAppThemeDataColorsXData() {
  return const AppThemeDataColorsX(
    primary: Color(0xfff6f4da),
    secondary: Color(0xff9e9e9e),
    someColor: Color(0xff000011),
    testColorSimple: Color(0xff000011),
    testColor: Color(0xff656213),
    simpleMapOfArray: <Color>[
      Color(0xff656213),
      Color(0xff000011),
    ],
    simpleMapOfArrayDark: <Color>[
      Color(0xff110022),
      Color(0xff000000),
    ],
    composite: Color(0xff9e9e9e),
  );
}

@immutable
class AppThemeDataColorsX extends ThemeExtension<AppThemeDataColorsX> {
  const AppThemeDataColorsX({
    required this.primary,
    required this.secondary,
    required this.someColor,
    required this.testColorSimple,
    required this.testColor,
    required this.simpleMapOfArray,
    required this.simpleMapOfArrayDark,
    required this.composite,
  });

  final Color? primary;
  final Color? secondary;
  final Color? someColor;
  final Color? testColorSimple;
  final Color? testColor;
  final List<Color>? simpleMapOfArray;
  final List<Color>? simpleMapOfArrayDark;
  final Color? composite;

  @override
  AppThemeDataColorsX copyWith({
    Color? primary,
    Color? secondary,
    Color? someColor,
    Color? testColorSimple,
    Color? testColor,
    List<Color>? simpleMapOfArray,
    List<Color>? simpleMapOfArrayDark,
    Color? composite,
  }) {
    return AppThemeDataColorsX(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      someColor: someColor ?? this.someColor,
      testColorSimple: testColorSimple ?? this.testColorSimple,
      testColor: testColor ?? this.testColor,
      simpleMapOfArray: simpleMapOfArray ?? this.simpleMapOfArray,
      simpleMapOfArrayDark: simpleMapOfArrayDark ?? this.simpleMapOfArrayDark,
      composite: composite ?? this.composite,
    );
  }

  @override
  AppThemeDataColorsX lerp(AppThemeDataColorsX? other, double t) {
    if (other is! AppThemeDataColorsX) {
      return this;
    }

    return AppThemeDataColorsX(
      primary: Color.lerp(primary, other.primary, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      someColor: Color.lerp(someColor, other.someColor, t),
      testColorSimple: Color.lerp(testColorSimple, other.testColorSimple, t),
      testColor: Color.lerp(testColor, other.testColor, t),
      simpleMapOfArray: simpleMapOfArray,
      simpleMapOfArrayDark: simpleMapOfArrayDark,
      composite: Color.lerp(composite, other.composite, t),
    );
  }
}
