import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark(
    useMaterial3: false,
  ).copyWith(
    textTheme: GoogleFonts.latoTextTheme().copyWith().apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusColor: AppColors.primary,
      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.white),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.primary),
        foregroundColor: MaterialStateProperty.all(AppColors.black),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}
