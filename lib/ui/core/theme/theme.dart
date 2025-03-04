import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    bottomSheetTheme: const BottomSheetThemeData(clipBehavior: Clip.hardEdge),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
    extensions: [],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    bottomSheetTheme: const BottomSheetThemeData(clipBehavior: Clip.hardEdge),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
    extensions: [],
  );
}
