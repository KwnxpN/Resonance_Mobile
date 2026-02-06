import 'package:flutter/material.dart';
import 'package:flutter_project/screens/login_screen.dart';
import './themes/app_theme.dart';
import './widgets/theme_preview_page.dart';
import './core/di/service_locator.dart';
import './screens/playlist_screen.dart';
import './screens/music_taste_screen.dart';
import './screens/register_screen.dart';
import './screens/music_playback_screen.dart';


void main() {
  ServiceLocator.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const HomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/music_taste': (context) => const MusicTasteScreen(),
        '/playlist': (context) => const PlaylistScreen(),
        '/music_playback': (context) => const MusicPlaybackScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ThemePreviewPage(),
                  ),
                );
              },
              child: const Text('Go to Theme Preview'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaylistScreen(),
                  ),
                );
              },
              child: const Text('Go to Playlist Screen'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MusicPlaybackScreen(),
                  ),
                );
              },
              child: const Text('Go to Music Playback Screen'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MusicTasteScreen(),
                  ),
                );
              },
              child: const Text('Go to Music Taste Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              },
              child: const Text('Go to Login Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
