import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class PlaylistHero extends StatelessWidget {
  final String title;
  final String? duration;

  const PlaylistHero({
    super.key,
    required this.title,
    this.duration,
  });

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

            // Playlist title with gradient
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [colors.onBackground, colors.primary],
                ).createShader(bounds),
                child: Text(
                  title,
                  style: AppTextStyles.text2xl(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Duration
            if (duration != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: colors.muted, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      duration!,
                      style: AppTextStyles.textSm(
                        context,
                      ).copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

