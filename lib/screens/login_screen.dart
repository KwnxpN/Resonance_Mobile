import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final auth = ServiceLocator.authRepository;

  bool hidePass = true;
  String? error;

  Future<void> login() async {
    try {
      await auth.login(
        email: emailCtrl.text,
        password: passCtrl.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login success")));
          final ok = await ServiceLocator.authRepository.checkSession();
          print("SESSION VALID = $ok");
    } catch (e) {
      setState(() => error = "Invalid login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF140016),
              Color(0xFF2A0033),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 40),

                const Icon(Icons.graphic_eq,
                    size: 60, color: Colors.pinkAccent),

                const SizedBox(height: 20),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Log in to sync your sound",
                  style: TextStyle(color: Colors.white60),
                ),

                const SizedBox(height: 32),

                _field(emailCtrl, "Email"),

                const SizedBox(height: 16),

                _field(passCtrl, "Password",
                    obscure: hidePass,
                    suffix: IconButton(
                      icon: Icon(
                        hidePass
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white54,
                      ),
                      onPressed: () =>
                          setState(() => hidePass = !hidePass),
                    )),

                if (error != null) ...[
                  const SizedBox(height: 12),
                  Text(error!,
                      style: const TextStyle(color: Colors.redAccent)),
                ],

                const SizedBox(height: 24),

                _pinkButton("LOG IN", login),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/register"),
                  child: const Text(
                    "New here? Join the club",
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label,
      {bool obscure = false, Widget? suffix}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0x33FFFFFF),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _pinkButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white70)),
      ),
    );
  }
}
