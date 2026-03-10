import 'package:flutter/material.dart';
import '../../features/users/models/user.dart';
import '../../screens/chat_screen.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class TopMatchCard extends StatelessWidget {
  final UserModel? user;
  final String matchId;
  final String currentUserId;

  const TopMatchCard({
    super.key,
    this.user,
    required this.matchId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.primary.withValues(alpha: 0.35), colors.surface],
          ),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Profile image + TOP MATCH badge
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.primary, width: 3),
                    image: user?.avatarUrl.isNotEmpty == true
                        ? DecorationImage(
                            image: NetworkImage(user!.avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: user?.avatarUrl.isNotEmpty != true
                      ? Icon(Icons.person, size: 50, color: colors.muted)
                      : null,
                ),
                Positioned(
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'TOP MATCH',
                      style: AppTextStyles.textXs(context).copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user?.displayName ?? 'Unknown',
                  style: AppTextStyles.textXl(context).copyWith(
                    color: colors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Bio
            if (user?.bio.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  user!.bio,
                  style: AppTextStyles.textXs(
                    context,
                  ).copyWith(color: colors.muted),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 16),

            // Chat button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          userName: user?.displayName ?? 'Unknown',
                          userImage: user?.avatarUrl ?? '',
                          matchId: matchId,
                          currentUserId: currentUserId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble, size: 20),
                  label: const Text('Chat with them'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: AppTextStyles.textMd(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
