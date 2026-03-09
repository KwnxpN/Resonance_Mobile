import 'package:flutter/material.dart';
import '../../features/musics/models/music_model.dart';
import '../../screens/music_playback_screen.dart';
import 'section_error.dart';
import 'track_image_card.dart';

class RecommendedSection extends StatelessWidget {
  final Future<List<TrackModel>> future;
  final VoidCallback onRetry;
  final VoidCallback onReturn;

  const RecommendedSection({
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
            'Recommend for you',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<TrackModel>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return SectionError(
                message: snapshot.hasError
                    ? 'Failed to load recommendations'
                    : 'No tracks available',
                onRetry: snapshot.hasError ? onRetry : null,
              );
            }

            final tracks = snapshot.data!;
            const pageSize = 9;
            final pageCount = (tracks.length / pageSize).ceil();

            return SizedBox(
              height: 400,
              child: PageView.builder(
                itemCount: pageCount,
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * pageSize;
                  final endIndex = (startIndex + pageSize).clamp(0, tracks.length);
                  final pageItems = tracks.sublist(startIndex, endIndex);

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1 / 1,
                    ),
                    itemCount: pageItems.length,
                    itemBuilder: (context, index) {
                      final globalIndex = pageIndex * pageSize + index;
                      return TrackImageCard(
                        track: pageItems[index],
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
                    },
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
