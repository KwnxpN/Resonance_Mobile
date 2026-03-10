import 'package:flutter/material.dart';

class AppTextStyles {
  // 4xl - Extra extra large
  static TextStyle text4xl(BuildContext context) {
    return TextStyle(
      fontSize: 56,
      fontWeight: FontWeight.bold,
    );
  }

  // 3xl - Extra large
  static TextStyle text3xl(BuildContext context) {
    return TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
    );
  }

  // 2xl - Very large
  static TextStyle text2xl(BuildContext context) {
    return TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );
  }

  // xl - Large
  static TextStyle textXl(BuildContext context) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );
  }

  // lg - Medium-large
  static TextStyle textLg(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );
  }

  // md - Medium (base)
  static TextStyle textMd(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );
  }

  // sm - Small
  static TextStyle textSm(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );
  }

  // xs - Extra small
  static TextStyle textXs(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    );
  }
}