import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/swipe_card.dart';
import '../widgets/music_taste_app_bar.dart';
import '../widgets/swipeable_card.dart';
import '../widgets/music_taste_result.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';


class MusicTasteScreen extends StatefulWidget {
  const MusicTasteScreen({super.key});

  @override
  State<MusicTasteScreen> createState() => _MusicTasteScreenState();
}

class _MusicTasteScreenState extends State<MusicTasteScreen> {
  late Future<List<TrackModel>> futureTracks;
  List<Track> tracks = [];
  bool initialized = false;
  bool finished = false;
  bool loadingError = false;

  Map<String, int> genreCounter = {};

  void handleSwipe(Track track, bool liked) {
    if (liked) {
      for (final genre in track.genre) {
        genreCounter[genre] = (genreCounter[genre] ?? 0) + 1;
      }
    }
    setState(() {
      if (tracks.isNotEmpty) tracks.removeLast();
    });

    if (tracks.isEmpty) {
      debugPrint('All tracks swiped!');
      debugPrint('User genre taste: $genreCounter');
      setState(() => finished = true);
    }
  }

  @override
  void initState() {
    super.initState();
    futureTracks = ServiceLocator.musicRepository.getRandomTracks();
  }

  Track _convertModelToTrack(TrackModel m) {
    // Robust conversion: artists/genres can be either List<String> or List<Map>
    String artist = '';
    try {
      if (m.artists.isNotEmpty) {
        final a = m.artists[0];
        artist = (a is Map && a['name'] != null) ? a['name'].toString() : a.toString();
      }
    } catch (_) {}

    List<String> genres = [];
    try {
      genres = m.genres.map((g) {
        if (g is Map && g['name'] != null) return g['name'].toString();
        return g.toString();
      }).cast<String>().toList();
    } catch (_) {}

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
                  if (finished) {
                    return MusicTasteResult(genreCounter: genreCounter);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load tracks',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'No tracks available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (!initialized) {
                    tracks = snapshot.data!.map((m) => _convertModelToTrack(m)).toList();
                    initialized = true;
                  }

                  if (tracks.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tracks available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Stack(
                    alignment: Alignment.center,
                    children: tracks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final track = entry.value;

                      if (index == tracks.length - 1) {
                        return SwipeableCard(
                          track: track,
                          onLike: () {
                            handleSwipe(track, true);
                          },
                          onDislike: () {
                            handleSwipe(track, false);
                          },
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SwipeCard(track: track,
                          onLike: () {},
                          onDislike: () {},
                        ),
                      );
                    }).toList(),
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

  