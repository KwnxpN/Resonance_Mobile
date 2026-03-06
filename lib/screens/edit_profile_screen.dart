import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/users/models/user.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameCtrl;
  late final TextEditingController _bioCtrl;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _displayNameCtrl = TextEditingController(text: widget.user.displayName);
    _bioCtrl = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final success = await ServiceLocator.userRepository.updateProfile(
      widget.user.userId,
      {
        'display_name': _displayNameCtrl.text.trim(),
        'bio': _bioCtrl.text.trim(),
      },
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      final updatedUser = UserModel(
        userId: widget.user.userId,
        email: widget.user.email,
        displayName: _displayNameCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
        avatarUrl: widget.user.avatarUrl,
        createdAt: widget.user.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );
      Navigator.pop(context, updatedUser);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.onBackground,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: AppTextStyles.textLg(context).copyWith(color: colors.onBackground),
        ),
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _save,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Color(0xFF911D58),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar (display only, editing skipped for now)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: widget.user.avatarUrl.isNotEmpty
                      ? NetworkImage(widget.user.avatarUrl)
                      : null,
                  child: widget.user.avatarUrl.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white54)
                      : null,
                ),
              ),

              const SizedBox(height: 32),

              // Display Name
              _fieldLabel('Display Name', colors),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _displayNameCtrl,
                hint: 'Enter your display name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Display name cannot be empty' : null,
              ),

              const SizedBox(height: 20),

              // Bio
              _fieldLabel('Bio', colors),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _bioCtrl,
                hint: 'Tell something about yourself...',
                maxLines: 4,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text, AppColors colors) {
    return Text(
      text,
      style: AppTextStyles.textSm(context).copyWith(
        color: colors.muted,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF3A1C2E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF911D58), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
