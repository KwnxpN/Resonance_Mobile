import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../core/di/service_locator.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../screens/music_playback_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ServiceLocator.playerController,
      builder: (context, _) {
        final controller = ServiceLocator.playerController;

        if (!controller.hasTrack) return const SizedBox.shrink();

        final colors = Theme.of(context).extension<AppColors>()!;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MusicPlaybackScreen(
                  tracks: controller.trackList,
                  initialIndex: controller.currentIndex,
                ),
              ),
            );
          },
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(
                top: BorderSide(color: colors.border, width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Artwork
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: controller.imageUrl.isNotEmpty
                      ? Image.network(
                          controller.imageUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(colors),
                        )
                      : _placeholder(colors),
                ),

                const SizedBox(width: 12),

                // Title & artist
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.songName,
                        style: AppTextStyles.textSm(context).copyWith(
                          color: colors.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        controller.artistName,
                        style: AppTextStyles.textXs(context).copyWith(
                          color: colors.muted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Play / Pause
                StreamBuilder<PlayerState>(
                  stream: controller.player.playerStateStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data?.playing ?? false;
                    return IconButton(
                      icon: Icon(
                        controller.isLoading
                            ? Icons.hourglass_empty
                            : playing
                                ? Icons.pause
                                : Icons.play_arrow,
                        color: colors.onBackground,
                        size: 28,
                      ),
                      onPressed: controller.isLoading
                          ? null
                          : playing
                              ? controller.player.pause
                              : controller.player.play,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder(AppColors colors) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(Icons.music_note, color: colors.muted, size: 20),
    );
  }
}
