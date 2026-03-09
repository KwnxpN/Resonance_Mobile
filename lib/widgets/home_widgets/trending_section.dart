import 'package:flutter/material.dart';
import '../../features/musics/models/music_model.dart';
import '../../screens/music_playback_screen.dart';
import '../../widgets/song_card.dart';
import 'section_error.dart';

class TrendingSection extends StatelessWidget {
  final Future<List<TrackModel>> future;
  final VoidCallback onRetry;
  final VoidCallback onReturn;

  const TrendingSection({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Trending Now',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<TrackModel>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return SectionError(
                message: snapshot.hasError
                    ? 'Failed to load trending tracks'
                    : 'No tracks available',
                onRetry: snapshot.hasError ? onRetry : null,
              );
            }

            final tracks = snapshot.data!;
            const carouselPageSize = 3;
            final pageCount = (tracks.length / carouselPageSize).ceil();

            return SizedBox(
              height: 240,
              child: PageView.builder(
                itemCount: pageCount,
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * carouselPageSize;
                  final endIndex =
                      (startIndex + carouselPageSize).clamp(0, tracks.length);
                  final pageItems = tracks.sublist(startIndex, endIndex);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: pageItems.asMap().entries.map((entry) {
                        final track = entry.value;
                        final globalIndex =
                            pageIndex * carouselPageSize + entry.key;
                        return SongCard(
                          track: track,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                  builder: (_) => MusicPlaybackScreen(
                                    tracks: tracks,
                                    initialIndex: globalIndex,
                                  ),
                                ))
                                .then((_) => onReturn());
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
