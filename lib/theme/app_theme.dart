// ignore_for_file: deprecated_member_use

import 'package:chat_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
    iconTheme: const IconThemeData(
      size: 25,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 2,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );

  static final darkTheme = ThemeData(
    androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    iconTheme: const IconThemeData(
      size: 25,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 2,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: AppColors.primaryColor,
    ),
  );
}
