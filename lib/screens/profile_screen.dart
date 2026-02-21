import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/music_player_card.dart'; // Ensure this path is correct
import '../widgets/vibe_chip.dart';
import '../widgets/artist_avatar.dart';
import '../widgets/menu_option.dart';
import '../core/di/service_locator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    // defined colors based on the image

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. User Header Section ---
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/300',
                      ), // Placeholder image
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'John Doe',
                      style: AppTextStyles.textXl(context).copyWith(
                        color: colors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@johndoe · New York, USA',
                      style: AppTextStyles.textMd(context).copyWith(
                        color: colors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // --- 2. Music Player Card (From previous request) ---
              const MusicPlayerCard(),

              const SizedBox(height: 24),

              // --- 3. My Vibe Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Vibe',
                    style: AppTextStyles.textLg(context).copyWith(
                      color: colors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: AppTextStyles.textMd(context).copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  const VibeChip(
                    label: 'Electronic',
                    icon: Icons.headphones,
                    color: Color(0xFF3F2033),
                  ),
                  const VibeChip(
                    label: 'Synthwave',
                    icon: Icons.piano,
                    color: Color(0xFF3F2033),
                  ),
                  const VibeChip(
                    label: 'Dream Pop',
                    icon: Icons.cloud,
                    color: Color(0xFF3F2033),
                  ),
                  const VibeChip(
                    label: 'Indie Rock',
                    icon: Icons.music_note_rounded,
                    color: Color(0xFF3F2033),
                  ),
                  // "Add Vibe" Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white24,
                        style: BorderStyle.solid,
                      ), // Dashed border requires external package or custom painter
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18, color: Colors.white70),
                        SizedBox(width: 6),
                        Text(
                          'Add Vibe',
                          style: AppTextStyles.textSm(
                            context,
                          ).copyWith(color: colors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- 4. Top Artists Section ---
              const Text(
                'Top Artists',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ArtistAvatar(
                    name: 'The Weeknd',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/e/e8/The_Weeknd_at_TIFF_2019.png',
                  ),
                  ArtistAvatar(
                    name: 'Daft Punk',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/a/a7/Daft_Punk_2013.jpg',
                  ),
                  ArtistAvatar(
                    name: 'Lana Del Rey',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/3/36/Lana_Del_Rey_Cannes_2012.jpg',
                  ),
                  ArtistAvatar(
                    name: 'Tame Impala',
                    imageUrl:
                        'https://upload.wikimedia.org/wikipedia/commons/2/29/Tame_Impala_Coachella_2015.jpg',
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- 5. Menu Options Section ---
              const MenuOption(
                icon: Icons.edit,
                title: 'Edit Profile',
                color: Color(0xFF911D58), // Darker pink icon bg
              ),
              const MenuOption(
                icon: Icons.notifications,
                title: 'Notifications',
                color: Color(0xFF4B3263), // Purple icon bg
              ),
              const SizedBox(height: 40),

              // --- 6. Logout Button ---
              GestureDetector(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF1E0F22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Log Out", style: TextStyle(color: Colors.white)),

                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await ServiceLocator.authRepository.logout();

                    if (!mounted) return;

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: const Color(0xFFB3261E),
                      width: 1.5,
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B0D1C), Color(0xFF2A0A15)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout, color: Color(0xFFFF6B6B)),
                      SizedBox(width: 10),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
