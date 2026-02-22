import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/swipeable_card.dart';
import '../widgets/music_taste_app_bar.dart';
import '../widgets/card_actions.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../main.dart';

class MusicTasteScreen extends StatefulWidget {
  const MusicTasteScreen({super.key});

  @override
  State<MusicTasteScreen> createState() => _MusicTasteScreenState();
}

class _MusicTasteScreenState extends State<MusicTasteScreen> {
  late Future<List<TrackModel>> futureTracks;

  int currentIndex = 0;
  Map<String, int> genreCounter = {};

  @override
  void initState() {
    super.initState();
    futureTracks = ServiceLocator.musicRepository.getRandomTracks();
  }

  void handleSwipe(List<Track> tracks, bool liked) async {
    final track = tracks[currentIndex];

    if (liked) {
      for (final genre in track.genre) {
        genreCounter[genre] = (genreCounter[genre] ?? 0) + 1;
      }
    }

    setState(() {
      currentIndex++;
    });

    if (currentIndex >= tracks.length) {
      try {
        await ServiceLocator.musicRepository.saveUserTaste(genreCounter);
      } catch (_) {}

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    }
  }

  Track _convertModelToTrack(TrackModel m) {
    String artist = '';
    if (m.artists.isNotEmpty) {
      final a = m.artists.first;
      if (a is Map && a['name'] != null) {
        artist = a['name'].toString();
      }
    }

    final genres = m.genres.map((g) {
      if (g is Map && g['name'] != null) {
        return g['name'].toString();
      }
      return g.toString();
    }).toList();

    return Track(
      title: m.name,
      artist: artist.isNotEmpty ? artist : 'Unknown',
      image: m.imageUrl,
      genre: genres,
      description: '',
      duration: m.duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120914),
      body: SafeArea(
        child: Column(
          children: [
            const MusicTasteAppBar(),

            Expanded(
              child: FutureBuilder<List<TrackModel>>(
                future: futureTracks,
                builder: (context, snapshot) {
                  // 🔄 Loading
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // ❌ Error
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Failed to load tracks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const MainScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text('Go to Home'),
                          ),
                        ],
                      ),
                    );
                  }

                  // ✅ Data Ready
                  final tracks = snapshot.data!
                      .map(_convertModelToTrack)
                      .toList();

                  if (currentIndex >= tracks.length) {
                    return const SizedBox();
                  }

                  return Stack(
  alignment: Alignment.center,
  children: [

    /// การ์ดด้านหลัง
    if (currentIndex + 1 < tracks.length)
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SwipeableCard(
          track: tracks[currentIndex + 1],
          onLike: () {},
          onDislike: () {},
        ),
      ),

    /// การ์ดด้านหน้า (ปัดได้)
    SwipeableCard(
      track: tracks[currentIndex],
      onLike: () => handleSwipe(tracks, true),
      onDislike: () => handleSwipe(tracks, false),
    ),

    /// ปุ่มลอย
    Positioned(
      left: 24,
      right: 24,
      bottom: 30,
      child: CardActions(
        onLike: () => handleSwipe(tracks, true),
        onDislike: () => handleSwipe(tracks, false),
      ),
    ),
  ],
);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}