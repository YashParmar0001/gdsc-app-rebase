import 'package:flutter/material.dart';
import 'package:gdsc_atmiya/theme/texts.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      textTheme: const TextTheme(
        displayLarge: AppTexts.displayLarge,
        displayMedium: AppTexts.displayMedium,
        headlineLarge: AppTexts.headlineLarge,
        headlineMedium: AppTexts.headlineMedium,
        headlineSmall: AppTexts.headlineSmall,
        titleLarge: AppTexts.titleLarge,
        titleMedium: AppTexts.titleMedium,
      ),
    );
  }
}