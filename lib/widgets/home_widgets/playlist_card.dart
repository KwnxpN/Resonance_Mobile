import 'package:flutter/material.dart';
import '../../features/playlists/models/playlist.dart';
import '../../screens/playlist_screen.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlist;
  final VoidCallback? onReturn;
  final bool isRecommended;

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.onReturn,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaylistScreen(
              playlistId: playlist.id,
              playlistName: playlist.name,
              tracks: playlist.tracks,
              isRecommended: isRecommended,
            ),
          ),
        ).then((_) => onReturn?.call());
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork placeholder
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withValues(alpha: 0.7),
                    colors.primaryVariant,
                  ],
                ),
              ),
              child: Icon(
                Icons.library_music,
                size: 48,
                color: colors.onPrimary.withValues(alpha: 0.8),
              ),
            ),

            // Playlist name
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                playlist.name,
                style: AppTextStyles.textSm(context).copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Track count
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                '${playlist.tracks.length} songs',
                style: AppTextStyles.textXs(context).copyWith(
                  color: colors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
