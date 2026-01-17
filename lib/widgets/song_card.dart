import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const SongCard({super.key, required this.song, this.onTap, this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isPlaying = song.isPlaying;

    return Material(
      color: isPlaying
          ? colors.primary.withValues(alpha: 0.15)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Album art / icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary.withValues(alpha: 0.6),
                      colors.surface,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.music_note_rounded,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Song info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: AppTextStyles.textMd(context).copyWith(
                        color: isPlaying ? colors.primary : colors.onBackground,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist,
                      style: AppTextStyles.textSm(
                        context,
                      ).copyWith(color: colors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Duration
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  song.duration,
                  style: AppTextStyles.textSm(
                    context,
                  ).copyWith(color: isPlaying ? colors.primary : colors.muted),
                ),
              ),

              // More button
              GestureDetector(
                onTap: onMoreTap,
                child: Icon(Icons.more_vert, color: colors.muted, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
