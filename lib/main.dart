import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_project/screens/login_screen.dart';
import './core/di/service_locator.dart';

import './themes/app_theme.dart';
import './themes/app_colors.dart';
import './themes/app_text_styles.dart';

import './screens/music_taste_screen.dart';
import './screens/register_screen.dart';
import './screens/home_screen.dart';
import './screens/playlist_screen.dart';
import './screens/profile_screen.dart';

// Allow all certificates (for development only)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // Enable certificate bypass for development
  HttpOverrides.global = MyHttpOverrides();
  
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
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const MainScreen(),
      },
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final loggedIn = await ServiceLocator.userRepository.checkSession();
    if (!mounted) return;
    if (loggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
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

  Future<void> _logout() async {
    await ServiceLocator.authRepository.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }
  
  late final List<Widget> _screens = [
    const HomeScreen(),
    const PlaylistScreen(),
    const MusicTasteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.graphic_eq, color: colors.primary, size: 32),
            const SizedBox(width: 8),
            Text("RESONANCE", style: AppTextStyles.textXl(context)),
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
