import 'package:flutter/material.dart';
import '../../features/match/models/match_model.dart';
import '../../features/users/models/user.dart';
import '../../screens/chat_screen.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class MatchList extends StatelessWidget {
  final List<MatchModel> matches;
  final Map<String, UserModel> userProfiles;
  final String currentUserId;

  const MatchList({
    super.key,
    required this.matches,
    required this.userProfiles,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    // Skip the first match (shown as TopMatchCard)
    final listMatches = matches.length > 1 ? matches.sublist(1) : <MatchModel>[];

    if (listMatches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No matches yet',
            style: AppTextStyles.textMd(context).copyWith(color: colors.muted),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: listMatches.length,
      separatorBuilder: (_, __) =>
          Divider(color: colors.border.withValues(alpha: 0.4), height: 1),
      itemBuilder: (context, index) {
        final match = listMatches[index];
        final otherUserId = match.userAId == currentUserId
            ? match.userBId
            : match.userAId;
        final user = userProfiles[otherUserId];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  image: user?.avatarUrl.isNotEmpty == true
                      ? DecorationImage(
                          image: NetworkImage(user!.avatarUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: user?.avatarUrl.isNotEmpty != true
                    ? Icon(Icons.person, size: 24, color: colors.muted)
                    : null,
              ),
              const SizedBox(width: 12),

              // Info column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'Unknown',
                      style: AppTextStyles.textMd(context).copyWith(
                        color: colors.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (user?.bio.isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Text(
                        user!.bio,
                        style: AppTextStyles.textXs(
                          context,
                        ).copyWith(color: colors.muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Message button → navigates to ChatScreen
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        userName: user?.displayName ?? 'Unknown',
                        userImage: user?.avatarUrl ?? '',
                        matchId: match.matchId,
                        currentUserId: currentUserId,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble,
                    color: colors.onPrimary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
