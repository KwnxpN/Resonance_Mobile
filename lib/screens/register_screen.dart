import 'package:flutter/material.dart';
import '../features/users/services/mock_auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final auth = MockAuthService();

  bool hidePass = true;
  String? error;

  Future<void> register() async {
    try {
      await auth.register(
        email: emailCtrl.text,
        password: passCtrl.text,
        name: nameCtrl.text,
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      setState(() => error = "Register failed");
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

                const Text(
                  "Find your rhythm",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Connect with fans like you",
                  style: TextStyle(color: Colors.white60),
                ),

                const SizedBox(height: 32),

                _field(nameCtrl, "Username"),
                const SizedBox(height: 16),
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

                _pinkButton("Start Listening →", register),
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
                fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
