import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import 'edit_profile_screen.dart';
import '../features/users/models/user.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/menu_option.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await ServiceLocator.userRepository.me();
    if (mounted) setState(() { _user = user; _loading = false; });
  }

  Future<void> _logout() async {
    await ServiceLocator.authRepository.logout();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil('/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Avatar + name + email ---
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[800],
                            backgroundImage: (_user?.avatarUrl.isNotEmpty == true)
                                ? NetworkImage(_user!.avatarUrl)
                                : null,
                            child: (_user?.avatarUrl.isNotEmpty == true)
                                ? null
                                : const Icon(Icons.person, size: 50, color: Colors.white54),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _user?.displayName.isNotEmpty == true
                                ? _user!.displayName
                                : 'No display name',
                            style: AppTextStyles.textXl(context).copyWith(
                              color: colors.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _user?.email ?? '—',
                            style: AppTextStyles.textMd(context)
                                .copyWith(color: colors.muted),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Bio ---
                    _sectionLabel('Bio', colors),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A1C2E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _user?.bio.isNotEmpty == true
                            ? _user!.bio
                            : 'No bio yet.',
                        style: TextStyle(
                          color: _user?.bio.isNotEmpty == true
                              ? Colors.white
                              : Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Info rows ---
                    _sectionLabel('Account Info', colors),
                    const SizedBox(height: 12),
                    _infoRow(Icons.calendar_today_outlined, 'Member since',
                        _formatDate(_user?.createdAt), colors),

                    const SizedBox(height: 30),

                    // --- Edit Profile ---
                    MenuOption(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      color: const Color(0xFF911D58),
                      onTap: () async {
                        if (_user == null) return;
                        final updated = await Navigator.push<UserModel>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(user: _user!),
                          ),
                        );
                        if (updated != null && mounted) {
                          setState(() => _user = updated);
                        }
                      },
                    ),

                    // --- Logout ---
                    MenuOption(
                      icon: Icons.logout,
                      title: 'Logout',
                      color: const Color(0xFF7B1C1C),
                      onTap: _logout,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _sectionLabel(String text, AppColors colors) {
    return Text(
      text,
      style: AppTextStyles.textLg(context).copyWith(
        color: colors.onBackground,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.muted),
          const SizedBox(width: 10),
          Text('$label: ',
              style: TextStyle(color: colors.muted, fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}