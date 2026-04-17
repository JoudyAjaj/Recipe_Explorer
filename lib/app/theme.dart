// إعدادات الثيم والألوان والخطوط العامة للتطبيق.
import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4F6D7A),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
  );
}
