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
  late List<String> _trackIds;

  @override
  void initState() {
    super.initState();
    _trackIds = List<String>.from(widget.tracks);
    _tracksFuture = _fetchTracks();
  }

  Future<List<TrackModel>> _fetchTracks() async {
    const batchSize = 5;
    final results = <TrackModel>[];
    for (var i = 0; i < _trackIds.length; i += batchSize) {
      final batch = _trackIds.sublist(
        i,
        (i + batchSize).clamp(0, _trackIds.length),
      );
      final batchResults = await Future.wait(
        batch.map((id) => ServiceLocator.musicRepository.getTrackById(id)),
      );
      results.addAll(batchResults);
    }
    return results;
  }

  Future<void> _removeTrack(String trackId) async {
    final success = await ServiceLocator.playlistRepository
        .removeTrackFromPlaylist(widget.playlistId, trackId);
    if (success) {
      setState(() => _trackIds.remove(trackId));
      _refreshTracks();
    }
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
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (_) => MusicPlaybackScreen(
                              tracks: snapshot.data!,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      menuItems: [
                        PopupMenuItem(
                          value: 'remove',
                          child: Text('Remove from Playlist'),
                        ),
                      ],
                      onMenuSelected: (value) {
                        if (value == 'remove') {
                          _removeTrack(track.id);
                        }
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
