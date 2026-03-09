import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/playlist_hero.dart';
import '../widgets/song_card.dart';
import 'music_playback_screen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.tracks,
  });

  final String playlistId;
  final String playlistName;
  final List<String> tracks;

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  // Future for fetching tracks from API
  late Future<List<TrackModel>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _tracksFuture = _fetchTracks();
  }

  Future<List<TrackModel>> _fetchTracks() {
    return Future.wait(
      widget.tracks.map(
        (id) => ServiceLocator.musicRepository.getTrackById(id),
      ),
    );
  }

  String _totalDuration(List<TrackModel> tracks) {
    int totalSeconds = 0;
    for (final track in tracks) {
      if (track.duration == null) continue;
      final parts = track.duration!.split(':');
      if (parts.length == 2) {
        totalSeconds +=
            (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
      }
    }
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s.toString().padLeft(2, '0')}s';
    return '${s}s';
  }

  void _refreshTracks() {
    setState(() {
      _tracksFuture = _fetchTracks();
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
                  title: widget.playlistName,
                  duration: snapshot.hasData
                      ? _totalDuration(snapshot.data!)
                      : null,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MusicPlaybackScreen(
                              tracks: snapshot.data!,
                              initialIndex: index,
                            ),
                          ),
                        );
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
