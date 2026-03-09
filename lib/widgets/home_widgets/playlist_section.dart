import 'package:flutter/material.dart';
import '../../features/playlists/models/playlist.dart';
import 'playlist_card.dart';
import 'section_error.dart';

class PlaylistSection extends StatelessWidget {
  final Future<List<PlaylistModel>> future;
  final VoidCallback onRetry;
  final VoidCallback onReturn;
  final VoidCallback onCreate;

  const PlaylistSection({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onReturn,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Playlists',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                tooltip: 'Create playlist',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<PlaylistModel>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return SectionError(
                message: 'Failed to load playlists',
                onRetry: onRetry,
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SectionError(message: 'No playlists yet');
            }

            final playlists = snapshot.data!;

            return SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: playlists.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    PlaylistCard(playlist: playlists[index], onReturn: onReturn),
              ),
            );
          },
        ),
      ],
    );
  }
}
