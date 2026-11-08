import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appTheme() {
  const paper = Color(0xFFF9F8F2);
  const panel = Color(0xFFFFFEF9);
  const ink = Color(0xFF18322B);
  const muted = Color(0xFF536961);
  const rule = Color(0xFFD9E1D7);
  const green = Color(0xFF195B48);

  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: green,
        brightness: Brightness.light,
      ).copyWith(
        primary: green,
        onPrimary: panel,
        surface: paper,
        onSurface: ink,
        onSurfaceVariant: muted,
        outline: rule,
      );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'Onest',
    scaffoldBackgroundColor: paper,
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineMedium: const TextStyle(
        fontFamily: 'Onest',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.9,
        color: ink,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'Onest',
        fontSize: 15,
        height: 1.5,
        color: ink,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'Onest',
        fontSize: 13,
        height: 1.5,
        color: muted,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'Onest',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontVariations: [FontVariation('wght', 650)],
      ),
      labelMedium: const TextStyle(
        fontFamily: 'Onest',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: ink,
        height: 1.2,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: paper,
      foregroundColor: green,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 56,
      titleSpacing: 19,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shape: Border(bottom: BorderSide(color: rule)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: panel,
      hintStyle: const TextStyle(color: muted, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: rule),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: rule),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: green, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        disabledBackgroundColor: rule,
        disabledForegroundColor: muted,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        textStyle: const TextStyle(
          fontFamily: 'Onest',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(color: rule, thickness: 1, space: 1),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: green,
      selectionColor: Color(0xFFC5DABB),
      selectionHandleColor: green,
    ),
  );
}
