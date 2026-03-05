import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/artwork_image.dart';

class MusicPlaybackScreen extends StatefulWidget {
  final List<TrackModel> tracks;
  final int initialIndex;

  const MusicPlaybackScreen({
    super.key,
    required this.tracks,
    this.initialIndex = 0,
  });

  @override
  State<MusicPlaybackScreen> createState() => _MusicPlaybackScreenState();
}

class _MusicPlaybackScreenState extends State<MusicPlaybackScreen> {
  @override
  void initState() {
    super.initState();
    ServiceLocator.playerController.loadTracks(widget.tracks, widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final controller = ServiceLocator.playerController;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  if (controller.isLoading) const LinearProgressIndicator(),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: IconButton.styleFrom(
                          foregroundColor: colors.onBackground,
                          iconSize: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        children: [
                          Text(
                            controller.isLoading ? 'Loading...' : 'NOW PLAYING',
                            style: AppTextStyles.textXs(context).copyWith(
                              color: colors.muted,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        style: IconButton.styleFrom(
                          foregroundColor: colors.onBackground,
                          iconSize: 28,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Artwork
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ArtworkImage(
                          imageUrl: controller.imageUrl.isNotEmpty
                              ? controller.imageUrl
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Controls
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          // Song info + actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.isLoading
                                          ? 'Loading...'
                                          : controller.songName,
                                      style: AppTextStyles.textXl(context)
                                          .copyWith(
                                        color: colors.onBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      controller.isLoading
                                          ? 'Loading...'
                                          : controller.artistName,
                                      style: AppTextStyles.textMd(context)
                                          .copyWith(color: colors.muted),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.playlist_add),
                                    style: IconButton.styleFrom(
                                      foregroundColor: colors.onBackground,
                                      iconSize: 28,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border),
                                    style: IconButton.styleFrom(
                                      foregroundColor: colors.onBackground,
                                      iconSize: 28,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Progress bar
                          StreamBuilder<Duration>(
                            stream: controller.player.positionStream,
                            builder: (_, snapshot) {
                              return ProgressBar(
                                progress: snapshot.data ?? Duration.zero,
                                total:
                                    controller.player.duration ?? Duration.zero,
                                onSeek: controller.player.seek,
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Playback controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Previous
                              IconButton(
                                icon: const Icon(Icons.skip_previous),
                                style: IconButton.styleFrom(
                                  foregroundColor: colors.onBackground,
                                  iconSize: 36,
                                ),
                                onPressed: controller.isLoading ||
                                        controller.currentIndex <= 0
                                    ? null
                                    : controller.playPrevious,
                              ),

                              // Play / Pause
                              StreamBuilder<PlayerState>(
                                stream: controller.player.playerStateStream,
                                builder: (context, snapshot) {
                                  final playing =
                                      snapshot.data?.playing ?? false;
                                  return IconButton(
                                    icon: Icon(
                                      playing
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                    ),
                                    style: IconButton.styleFrom(
                                      foregroundColor: colors.onBackground,
                                      backgroundColor: colors.primary,
                                      iconSize: 64,
                                    ),
                                    onPressed: playing
                                        ? controller.player.pause
                                        : controller.player.play,
                                  );
                                },
                              ),

                              // Next
                              IconButton(
                                icon: const Icon(Icons.skip_next),
                                style: IconButton.styleFrom(
                                  foregroundColor: colors.onBackground,
                                  iconSize: 36,
                                ),
                                onPressed: controller.isLoading ||
                                        controller.currentIndex >=
                                            controller.trackList.length - 1
                                    ? null
                                    : controller.playNext,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Friends listening
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.muted.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: colors.muted),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 24,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundColor: colors.primary,
                                              child: Icon(Icons.person,
                                                  size: 12,
                                                  color: colors.onBackground),
                                            ),
                                          ),
                                          Positioned(
                                            left: 14,
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundColor: colors.primary,
                                              child: Icon(Icons.person,
                                                  size: 12,
                                                  color: colors.onBackground),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '12 Friends Listening',
                                      style: AppTextStyles.textSm(context)
                                          .copyWith(
                                        color: colors.onBackground,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
