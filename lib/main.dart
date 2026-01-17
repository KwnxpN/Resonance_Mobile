import 'package:flutter/material.dart';
import './themes/app_theme.dart';
import './widgets/theme_preview_page.dart';
import './screens/playlist_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const PlaylistScreen(),
    );
  }
}
