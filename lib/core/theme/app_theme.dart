// إعدادات الثيم والألوان والخطوط العامة للتطبيق.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  const Color accentIconColor = Color(0xFFFF5A30);
  const Color inactiveIconColor = Color(0xFFBDBDBD);
  const Color seed = Color(0xFF355C7D);
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: seed, // نستخدم لون البذرة لتوليد نظام ألوان متناسق.
    brightness: Brightness.light, // نختار سطوع فاتح ليتناسب مع تصميمنا العام.
    surface: const Color(0xFFFAF7F2), // لون خلفية عام لجميع الشاشات.
  );

  final TextTheme textTheme = GoogleFonts.poppinsTextTheme().copyWith( // نستخدم خط Poppins للنصوص العادية و Playfair Display للعناوين لإضفاء طابع مميز وأنيق.
    headlineLarge: GoogleFonts.playfairDisplay( // العنوان الرئيسي في التطبيق، مثل اسم التطبيق في الشاشة الرئيسية أو عنوان التصنيف.
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface, // نستخدم لون النص المناسب حسب نظام الألوان المولد.
    ),
    headlineMedium: GoogleFonts.playfairDisplay( //
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      color: colorScheme.onSurface,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: colorScheme.onSurfaceVariant,
    ),
  );

  return ThemeData(
    useMaterial3: true,  //
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme( //
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        final bool isSelected = states.contains(WidgetState.selected);
        return textTheme.labelMedium!.copyWith(
          color: isSelected ? accentIconColor : inactiveIconColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        final bool isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected ? accentIconColor : inactiveIconColor,
          size: 26,
        );
      }),
    ),
  );
}
