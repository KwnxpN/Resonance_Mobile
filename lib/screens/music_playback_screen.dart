import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/artwork_image.dart';
import '../widgets/add_to_playlist_sheet.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ServiceLocator.playerController.loadTracks(
        widget.tracks,
        widget.initialIndex,
      );
    });
  }

  Future<void> _showAddToPlaylistDrawer(BuildContext context) async {
    final colors = Theme.of(context).extension<AppColors>()!;
    final controller = ServiceLocator.playerController;
    final trackId = controller.trackList[controller.currentIndex].id;

    final user = await ServiceLocator.userRepository.me();
    if (user == null || !context.mounted) return;

    final playlists = await ServiceLocator.playlistRepository
        .getPersonalPlaylists(user.userId);
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddToPlaylistSheet(
        playlists: playlists,
        trackId: trackId,
      ),
    );
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
                                      style: AppTextStyles.textMd(
                                        context,
                                      ).copyWith(color: colors.muted),
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
                                    onPressed: controller.isLoading
                                        ? null
                                        : () => _showAddToPlaylistDrawer(context),
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
                                onPressed: controller.isLoading
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
                                onPressed: controller.isLoading
                                    ? null
                                    : controller.playNext,
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