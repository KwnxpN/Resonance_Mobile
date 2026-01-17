import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../themes/app_colors.dart';
import '../widgets/playlist_hero.dart';
import '../widgets/song_card.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  // Using mock data for static design
  final Playlist _playlist = mockPlaylist;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
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
                // Handle shuffle play
              },
            ),
          ),

          // Songs list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final song = _playlist.songs[index];
              return SongCard(
                song: song,
                onTap: () {
                  // Handle song tap
                },
                onMoreTap: () {
                  // Handle more options
                },
              );
            }, childCount: _playlist.songs.length),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
