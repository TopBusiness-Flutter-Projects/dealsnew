import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_strings.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primary,
    hintColor: AppColors.hint,

    brightness: Brightness.light,
    // scaffoldBackgroundColor: AppColors.scaffoldBackground,
    fontFamily: AppStrings.fontFamily,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 18.0, fontFamily: AppStrings.fontFamily
          // fontWeight: FontWeight.bold,
          ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: AppColors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 22.0,
        fontFamily: AppStrings.fontFamily,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

ThemeData appDarkTheme() {
  return ThemeData(
    primaryColor: AppColors.white,
    hintColor: AppColors.hint,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.blackLite,
    fontFamily: AppStrings.fontFamily,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontFamily: AppStrings.fontFamily,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: AppColors.transparent,
      titleTextStyle: const TextStyle(
        fontFamily: AppStrings.fontFamily,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
