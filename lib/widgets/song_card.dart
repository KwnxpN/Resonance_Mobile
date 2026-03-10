import 'package:flutter/material.dart';
import '../features/musics/models/music_model.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class SongCard extends StatelessWidget {
  final TrackModel track;
  final bool isPlaying;
  final VoidCallback? onTap;
  final List<PopupMenuEntry<String>>? menuItems;
  final void Function(String)? onMenuSelected;

  const SongCard({
    super.key,
    required this.track,
    this.isPlaying = false,
    this.onTap,
    this.menuItems,
    this.onMenuSelected,
  });

  String get _artistsText {
    if (track.artist.isEmpty) return 'Unknown Artist';
    return track.artist;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

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
              // Album art
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: track.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(track.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                  gradient: track.imageUrl.isEmpty
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors.primary.withValues(alpha: 0.6),
                            colors.surface,
                          ],
                        )
                      : null,
                ),
                child: track.imageUrl.isEmpty
                    ? Icon(
                        Icons.music_note_rounded,
                        color: colors.primary,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Track info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.name,
                      style: AppTextStyles.textMd(context).copyWith(
                        color: isPlaying ? colors.primary : colors.onBackground,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _artistsText,
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
                  track.duration ?? '',
                  style: AppTextStyles.textSm(
                    context,
                  ).copyWith(color: isPlaying ? colors.primary : colors.muted),
                ),
              ),

              // More button
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert, color: colors.muted, size: 20),
                enabled: menuItems != null && menuItems!.isNotEmpty,
                itemBuilder: (_) => menuItems ?? [],
                onSelected: onMenuSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
