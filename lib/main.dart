import 'package:flutter/material.dart';
import 'package:flutter_project/screens/login_screen.dart';
import './themes/app_theme.dart';
import './widgets/theme_preview_page.dart';
import './core/di/service_locator.dart';
import './screens/playlist_screen.dart';
import './screens/music_taste_screen.dart';
import './screens/register_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServiceLocator.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),

      initialRoute: "/login",

      routes: {
        "/login": (_) => const LoginPage(),
        "/register": (_) => const RegisterPage(),
        "/playlist": (_) => const PlaylistScreen(),
        "/taste": (_) => const MusicTasteScreen(),
      },
    );
  }
}
