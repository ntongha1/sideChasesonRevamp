import 'package:sonalysis/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightThemeData() {
    return ThemeData(
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: AppColors.sonaPurple1),
      fontFamily: 'Avenir',
      primaryColor: Colors.white,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      // scaffoldBackgroundColor: AppColors.background,
      focusColor: AppColors.sonaPurple2,
      hintColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      dividerColor: Colors.transparent,
    );
  }
}
