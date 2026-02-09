import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  final auth = ServiceLocator.authRepository;

  bool hidePass = true;
  String? error;
  bool loading = false;

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
      error = null;
    });

    try {
      await auth.register(
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
        name: nameCtrl.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = "Register failed");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF140016), Color(0xFF2A0033)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    "Find your rhythm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _nameField(),
                  const SizedBox(height: 16),

                  _emailField(),
                  const SizedBox(height: 16),

                  _passwordField(),

                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(error!,
                        style: const TextStyle(color: Colors.redAccent)),
                  ],

                  const SizedBox(height: 24),

                  _submitButton(
                    loading ? "Loading..." : "Start Listening",
                    loading ? null : register,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      controller: nameCtrl,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDeco("Username"),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return "Name is required";
        }
        if (v.trim().length < 3) {
          return "Name too short";
        }
        return null;
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: emailCtrl,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDeco("Email"),
      validator: (v) {
        if (v == null || v.isEmpty) return "Email required";

        final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
        if (!ok) return "Invalid email";

        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: passCtrl,
      obscureText: hidePass,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDeco("Password").copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            hidePass ? Icons.visibility_off : Icons.visibility,
            color: Colors.white54,
          ),
          onPressed: () => setState(() => hidePass = !hidePass),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "Password required";
        if (v.length < 8) return "Min 8 characters";
        return null;
      },
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0x33FFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.orangeAccent),
    );
  }

  Widget _submitButton(String text, VoidCallback? onTap) {
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
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
