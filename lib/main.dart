import 'package:flutter/material.dart';
import './themes/app_theme.dart';
import './widgets/theme_preview_page.dart';
import './core/di/service_locator.dart';
import './screens/playlist_screen.dart';

void main() {
  ServiceLocator.init();
  ServiceLocator.musicRepository.getRandomTracks().then((tracks) {
    print(tracks); // Now this prints the actual data
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const PlaylistScreen(),
    );
  }
}