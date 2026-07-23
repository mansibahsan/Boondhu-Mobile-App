import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_typograpghy.dart'; // Make sure this matches your filename!

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // Setting up the default App Bar (the top Navy bar in your design)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      // Applying your Typography to the whole app
      textTheme: TextTheme(
        headlineLarge: AppTypography.heading1,
        bodyMedium: AppTypography.bodyText,
      ),

      // Making buttons look like your design (rounded-xl)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
