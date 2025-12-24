import 'package:e_contrat/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF6366F1); // Indigo 500
  static const _secondary = Color(0xFFEC4899); // Pink 500
  static const _accent = Color(0xFF8B5CF6); // Violet 500

  static ThemeData light(BuildContext context) =>
      _theme(context, isDark: false);
  static ThemeData dark(BuildContext context) => _theme(context, isDark: true);

  static ThemeData _theme(BuildContext context, {required bool isDark}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      secondary: _secondary,
      tertiary: _accent,
      brightness: isDark ? Brightness.dark : Brightness.light,
      surface: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      surfaceContainerHighest: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF1F5F9),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: isDark
            ? const Color(0xFFF8FAFC)
            : const Color(0xFF1E293B),
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          fontSize: context.rf(24),
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.rs(24)),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: isDark ? 0.1 : 0.5),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(16),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, context.rs(56)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.rs(16)),
          ),
          textStyle: TextStyle(
            fontSize: context.rf(16),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: isDark ? 12 : 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.rs(20)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark
            ? const Color(0xFFF1F5F9)
            : const Color(0xFF1E293B),
        contentTextStyle: TextStyle(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.rs(16)),
        ),
      ),
    );
  }
}
