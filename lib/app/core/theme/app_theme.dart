import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voicechat/app/core/theme/app_color.dart';

ThemeData lightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.PRIMARY,
    ),
    scaffoldBackgroundColor: AppColor.NEUTRAL_100,
    useMaterial3: true,
    textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
      bodyColor: AppColor.NEUTRAL_700,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: AppColor.NEUTRAL_700,
      ),
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: AppColor.NEUTRAL_700,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleSpacing: 16,
      centerTitle: false,
      scrolledUnderElevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.PRIMARY,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColor.NEUTRAL_200,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}
