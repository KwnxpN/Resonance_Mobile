import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import './themes/app_theme.dart';
import './widgets/theme_preview_page.dart';

void main() {
  ServiceLocator.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final tracks = ServiceLocator.musicRepository.getTracks();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const ThemePreviewPage(),
    );
  }
}