import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import 'chat_screen.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Vibe Tribe',
                    style: AppTextStyles.textXl(context).copyWith(
                      color: colors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.search, color: colors.onSurface, size: 24),
                      const SizedBox(width: 16),
                      Icon(Icons.tune, color: colors.onSurface, size: 24),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Top Match Hero Card ──
            _buildTopMatchCard(context, colors),

            const SizedBox(height: 24),

            // ── Your Matches ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Your Matches',
                style: AppTextStyles.textLg(context).copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildMatchList(context, colors),
          ],
        ),
      ),
    );
  }

  // ─────────────────── Top Match Hero Card ───────────────────
  Widget _buildTopMatchCard(BuildContext context, AppColors colors) {
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
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
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

            // Name + verified
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Alex, 24',
                  style: AppTextStyles.textXl(context).copyWith(
                    color: colors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.verified, color: Colors.blue.shade400, size: 20),
              ],
            ),
            const SizedBox(height: 4),

            // Compatibility %
            Text(
              '98% Compatibility',
              style: AppTextStyles.textSm(
                context,
              ).copyWith(color: colors.primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),

            Text(
              'Both obsessed with Daft Punk & Justice',
              style: AppTextStyles.textXs(
                context,
              ).copyWith(color: colors.muted),
            ),

            const SizedBox(height: 16),

            // Play Their Anthem button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_circle_fill, size: 20),
                  label: const Text('Play Their Anthem'),
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

  // ─────────────────── New Matches Row ───────────────────
  Widget _buildNewMatchesRow(BuildContext context, AppColors colors) {
    final matches = [
      {'name': 'Discovery', 'icon': true},
      {
        'name': 'Sarah',
        'image':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'Marcus',
        'image':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'Chloe',
        'image':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'David',
        'image':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&crop=face',
      },
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: matches.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final match = matches[index];
          final isDiscovery = match['icon'] == true;

          return Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isDiscovery
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colors.primary, colors.accent],
                        ),
                  color: isDiscovery
                      ? colors.primary.withValues(alpha: 0.2)
                      : null,
                ),
                child: isDiscovery
                    ? Icon(Icons.bolt, color: colors.primary, size: 28)
                    : Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(match['image'] as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                match['name'] as String,
                style: AppTextStyles.textXs(
                  context,
                ).copyWith(color: colors.onSurface.withValues(alpha: 0.8)),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────── Your Matches List ───────────────────
  Widget _buildMatchList(BuildContext context, AppColors colors) {
    final matchData = [
      {
        'name': 'Mia',
        'age': '23',
        'percent': '94',
        'bio': 'Techno & House lover 🎵',
        'tags': ['PEGGY GOU', 'SOLOMUN'],
        'image':
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'Liam',
        'age': '26',
        'percent': '89',
        'bio': 'Indie Rocker 🎸',
        'tags': ['ARCTIC MONKEYS', '+2'],
        'image':
            'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'Zoe',
        'age': '22',
        'percent': '85',
        'bio': 'R&B Vibes only ✨',
        'tags': ['SZA', 'THE WEEKND'],
        'image':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop&crop=face',
      },
      {
        'name': 'Noah',
        'age': '25',
        'percent': '76',
        'bio': 'Jazz & Lo-fi',
        'tags': ['MILES DAVIS'],
        'image':
            'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100&h=100&fit=crop&crop=face',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: matchData.length,
      separatorBuilder: (_, __) =>
          Divider(color: colors.border.withValues(alpha: 0.4), height: 1),
      itemBuilder: (context, index) {
        final m = matchData[index];
        final tags = m['tags'] as List<String>;

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
                  image: DecorationImage(
                    image: NetworkImage(m['image'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name, age, percent
                    Row(
                      children: [
                        Text(
                          '${m['name']}, ${m['age']}',
                          style: AppTextStyles.textMd(context).copyWith(
                            color: colors.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${m['percent']}%',
                          style: AppTextStyles.textSm(context).copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Bio
                    Text(
                      m['bio'] as String,
                      style: AppTextStyles.textXs(
                        context,
                      ).copyWith(color: colors.muted),
                    ),
                    const SizedBox(height: 6),

                    // Tags
                    Wrap(
                      spacing: 6,
                      children: tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: colors.border,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: AppTextStyles.textXs(context).copyWith(
                                  color: colors.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
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
                        userName: '${m['name']}',
                        userImage: m['image'] as String,
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
