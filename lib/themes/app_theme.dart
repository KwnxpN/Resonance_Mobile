import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0C0812),
      extensions: const [
        AppColors(
          primary: Color(0xFFF20D93),
          primaryVariant: Color(0xFFbf0a74),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFFFFFFFF),
          secondaryVariant: Color(0xFFcccccc),
          onSecondary: Color(0xFF000000),
          background: Color(0xFF22101b),
          onBackground: Color(0xFFFFFFFF),
          surface: Color(0xFF361A2B),
          onSurface: Color(0xFFFFFFFF),
          accent: Color(0xFF5C2C49),
          border: Color(0xFF492239),
          muted: Color(0xFF85747E),
          success: Color(0xFF4CAF50),
          onSuccess: Color(0xFFFFFFFF),
          warning: Color(0xFFFFC107),
          onWarning: Color(0xFF000000),
          error: Color(0xFFF44336),
          onError: Color(0xFFFFFFFF),
          info: Color(0xFFF20D93),
          onInfo: Color(0xFFFFFFFF),
        ),
      ],
    );
  }
}