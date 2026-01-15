import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  static LinearGradient authOverlay(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        c.background.withValues(alpha: 0.6),
        c.background.withValues(alpha: 0.85),
        c.background,
      ],
    );
  }
}