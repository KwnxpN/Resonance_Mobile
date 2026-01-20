import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../models/mock_data.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/playlist_hero.dart';
import '../widgets/song_card.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  // Using mock data for playlist info
  final Playlist _playlist = mockPlaylist;

  // Future for fetching tracks from API
  late Future<List<TrackModel>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _tracksFuture = ServiceLocator.musicRepository.getRandomTracks();
  }

  void _refreshTracks() {
    setState(() {
      _tracksFuture = ServiceLocator.musicRepository.getRandomTracks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: FutureBuilder<List<TrackModel>>(
        future: _tracksFuture,
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              // Hero section
              SliverToBoxAdapter(
                child: PlaylistHero(
                  playlist: _playlist,
                  onLikeTap: () {
                    // Handle like
                  },
                  onDownloadTap: () {
                    // Handle download
                  },
                  onShuffleTap: () {
                    _refreshTracks();
                  },
                ),
              ),

              // Content based on state
              if (snapshot.connectionState == ConnectionState.waiting)
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  ),
                )
              else if (snapshot.hasError)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: colors.muted,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load tracks',
                          style: AppTextStyles.textMd(
                            context,
                          ).copyWith(color: colors.muted),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshTracks,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (!snapshot.hasData || snapshot.data!.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No tracks found',
                      style: AppTextStyles.textMd(
                        context,
                      ).copyWith(color: colors.muted),
                    ),
                  ),
                )
              else ...[
                // Tracks list
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final track = snapshot.data![index];
                    return SongCard(
                      track: track,
                      onTap: () {
                        // Handle track tap
                      },
                      onMoreTap: () {
                        // Handle more options
                      },
                    );
                  }, childCount: snapshot.data!.length),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ],
          );
        },
      ),
    );
  }
}
