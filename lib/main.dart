import 'package:flutter/material.dart';
import 'package:flutter_project/screens/login_screen.dart';
import './themes/app_theme.dart';
import './core/di/service_locator.dart';

import './themes/app_theme.dart';
import './themes/app_colors.dart';

import './screens/music_taste_screen.dart';
import './screens/register_screen.dart';
import './screens/home_screen.dart';
import './screens/music_playback_screen.dart';
import './screens/playlist_screen.dart';


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
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/music_taste': (context) => const MusicTasteScreen(),
        '/playlist': (context) => const PlaylistScreen(),
        '/music_playback': (context) => const MusicPlaybackScreen(),
      },
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomeScreen(),
      Center(child: Text('Discover Screen')),
      MusicTasteScreen(),
      Center(child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(),
                    ),
                  );
                },
                child: const Text('Go to Login Screen'),
              ),),
    ];
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Row(
          children: [
            Row(
              children: [
                Icon(Icons.graphic_eq, color: colors.primary, size: 32),
                const SizedBox(width: 8),
                const Text("RESONANCE", style: TextStyle()),
              ],
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.background,
          border: Border(top: BorderSide(color: colors.border, width: 1.5)),
        ),

        child: SafeArea(
          child: SizedBox(
            height: 80,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),

              type: BottomNavigationBarType.fixed,
              backgroundColor: colors.background,
              selectedItemColor: colors.primary,
              unselectedItemColor: colors.onSurface.withValues(alpha: 0.6),
              iconSize: 28,
              elevation: 0,

              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Matches',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
