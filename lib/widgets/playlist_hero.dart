import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class PlaylistHero extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback? onLikeTap;
  final VoidCallback? onDownloadTap;
  final VoidCallback? onShuffleTap;

  const PlaylistHero({
    super.key,
    required this.playlist,
    this.onLikeTap,
    this.onDownloadTap,
    this.onShuffleTap,
  });

  String _formatLikes(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.primary.withValues(alpha: 0.3), colors.background],
          stops: const [0.0, 0.8],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back and more buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.chevron_left,
                      color: colors.onBackground,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                      color: colors.onBackground,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // Cover image placeholder with neon glow effect
            Center(
              child: Container(
                width: 220,
                height: 160,
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.5),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary.withValues(alpha: 0.8),
                      colors.surface,
                      colors.primary.withValues(alpha: 0.4),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Decorative neon lines
                      Positioned(
                        top: 20,
                        right: -20,
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Container(
                            width: 120,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.primary,
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: 0,
                        child: Transform.rotate(
                          angle: -0.3,
                          child: Container(
                            width: 100,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        right: -10,
                        child: Transform.rotate(
                          angle: 0.4,
                          child: Container(
                            width: 80,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Playlist tag
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  playlist.tag,
                  style: AppTextStyles.textXs(context).copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Playlist title with gradient
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [colors.onBackground, colors.primary],
                ).createShader(bounds),
                child: Text(
                  playlist.title,
                  style: AppTextStyles.text2xl(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                playlist.description,
                style: AppTextStyles.textSm(
                  context,
                ).copyWith(color: colors.muted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),

            // Stats row (likes and duration)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: colors.primary, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${_formatLikes(playlist.likesCount)} Likes',
                    style: AppTextStyles.textSm(
                      context,
                    ).copyWith(color: colors.muted),
                  ),
                  const SizedBox(width: 20),
                  Icon(Icons.access_time, color: colors.muted, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    playlist.totalDuration,
                    style: AppTextStyles.textSm(
                      context,
                    ).copyWith(color: colors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Like button
                  _ActionButton(
                    icon: Icons.favorite_border,
                    onTap: onLikeTap,
                    colors: colors,
                  ),
                  const SizedBox(width: 16),

                  // Download button
                  _ActionButton(
                    icon: Icons.download_outlined,
                    onTap: onDownloadTap,
                    colors: colors,
                  ),

                  const Spacer(),

                  // Shuffle button
                  Material(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: onShuffleTap,
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              color: colors.onPrimary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'SHUFFLE',
                              style: AppTextStyles.textMd(context).copyWith(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final AppColors colors;

  const _ActionButton({required this.icon, this.onTap, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: colors.border, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: colors.onBackground, size: 22),
        ),
      ),
    );
  }
}
