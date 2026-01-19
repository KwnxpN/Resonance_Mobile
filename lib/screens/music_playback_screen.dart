import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/artwork_image.dart';

class MusicPlaybackScreen extends StatefulWidget {
  const MusicPlaybackScreen({super.key});

  @override
  _MusicPlaybackScreenState createState() => _MusicPlaybackScreenState();
}

class _MusicPlaybackScreenState extends State<MusicPlaybackScreen> {
  String _songTitle = 'Song Title';
  String _artistName = 'Artist Name';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              // Header with close and more options buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: IconButton.styleFrom(
                      foregroundColor: colors.onBackground,
                      iconSize: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  // Playlist title
                  Column(
                    children: [
                      Text(
                        'PLAYING FROM PLAYLIST',
                        style: AppTextStyles.textXs(context).copyWith(
                          color: colors.muted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Playlist Name',
                        style: AppTextStyles.textMd(context).copyWith(
                          color: colors.onBackground,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // More options button
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    style: IconButton.styleFrom(
                      foregroundColor: colors.onBackground,
                      iconSize: 28,
                    ),
                    onPressed: () {
                      // Handle more options action
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Music Artwork
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ArtworkImage(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuC2QC8Wz7IX96K0iDdGouOsx-7HvVoht5QG2p7PX3FVFo7XLvZsJCfqYMhI0xRM1XX2NNEoM_4EmpQOSBnITLKbn6Dp6N31vqFDP_DS6a3q9mytsJUQZXICfuYlfj4QQjypr4fQN8JbfgfOnlxXlQ3WaP2IwgSxIllLTdpHcpJHsyNaIoSVbMIvHu5c0l7Ux3Yd1ihOgeyQGQ6oZW0HTvSOlIvUGEm7XpAR3-cBy0ykqtbj7wVrJBaE5I9xrpSwaXsD4yj2Tu6fV3-Q',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Control Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      // Song title / Artist, add to playlist, favorite
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Song title and artist
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Song Title',
                                style: AppTextStyles.textXl(context).copyWith(
                                  color: colors.onBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Artist Name',
                                style: AppTextStyles.textMd(
                                  context,
                                ).copyWith(color: colors.muted),
                              ),
                            ],
                          ),

                          // Action buttons
                          Row(
                            children: [
                              // Add to playlist
                              IconButton(
                                icon: const Icon(Icons.playlist_add),
                                style: IconButton.styleFrom(
                                  foregroundColor: colors.onBackground,
                                  iconSize: 28,
                                ),
                                onPressed: () {
                                  // Handle add to playlist action
                                },
                              ),

                              // Favorite
                              IconButton(
                                icon: const Icon(Icons.favorite_border),
                                style: IconButton.styleFrom(
                                  foregroundColor: colors.onBackground,
                                  iconSize: 28,
                                ),
                                onPressed: () {
                                  // Handle favorite action
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Progress bar
                      ProgressBar(
                        progress: Duration(minutes: 0, seconds: 20),
                        buffered: Duration(minutes: 1, seconds: 50),
                        total: Duration(minutes: 5, seconds: 0),
                        progressBarColor: colors.primary,
                        bufferedBarColor: colors.onBackground,
                        timeLabelTextStyle: AppTextStyles.textSm(
                          context,
                        ).copyWith(color: colors.muted),
                        timeLabelPadding: 8,
                      ),

                      const SizedBox(height: 24),

                      // Playback controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Shuffle
                          IconButton(
                            icon: const Icon(Icons.shuffle),
                            style: IconButton.styleFrom(
                              foregroundColor: colors.muted,
                              iconSize: 28,
                            ),
                            onPressed: () {
                              // Handle shuffle action
                            },
                          ),

                          // Previous
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            style: IconButton.styleFrom(
                              foregroundColor: colors.onBackground,
                              iconSize: 36,
                            ),
                            onPressed: () {
                              // Handle previous action
                            },
                          ),

                          // Play/Pause
                          IconButton(
                            icon: const Icon(Icons.play_circle_fill),
                            style: IconButton.styleFrom(
                              foregroundColor: colors.onBackground,
                              backgroundColor: colors.primary,
                              iconSize: 56,
                              padding: const EdgeInsets.all(16),
                            ),
                            onPressed: () {
                              // Handle play/pause action
                            },
                          ),

                          // Next
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            style: IconButton.styleFrom(
                              foregroundColor: colors.onBackground,
                              iconSize: 36,
                            ),
                            onPressed: () {
                              // Handle next action
                            },
                          ),

                          // Repeat
                          IconButton(
                            icon: const Icon(Icons.repeat),
                            style: IconButton.styleFrom(
                              foregroundColor: colors.primary,
                              iconSize: 28,
                            ),
                            onPressed: () {
                              // Handle repeat action
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Friends Listening Counter and Lyrics Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Friends Listening Counter
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
                                // Friend avatars stack
                                SizedBox(
                                  width: 40,
                                  height: 24,
                                  child: Stack(
                                    children: [
                                      // Replace with actual friend avatars
                                      Positioned(
                                        left: 0,
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: colors.primary,
                                          child: Icon(
                                            Icons.person,
                                            size: 12,
                                            color: colors.onBackground,
                                          ),
                                        ),
                                      ),
                                      // Replace with actual friend avatars
                                      Positioned(
                                        left: 14,
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: colors.primary,
                                          child: Icon(
                                            Icons.person,
                                            size: 12,
                                            color: colors.onBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '12 Friends Listening',
                                  style: AppTextStyles.textSm(context).copyWith(
                                    color: colors.onBackground,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Lyrics Button
                          IconButton(
                            icon: const Icon(Icons.lyrics),
                            onPressed: () {
                              // Handle lyrics action
                            },
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
  }
}
