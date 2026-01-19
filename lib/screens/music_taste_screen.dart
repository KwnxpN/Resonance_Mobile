import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/swipe_card.dart';
import '../widgets/music_taste_app_bar.dart';
import '../services/track_api.dart';
import '../widgets/swipeable_card.dart';
import '../widgets/music_taste_result.dart';

class MusicTasteScreen extends StatefulWidget {
  const MusicTasteScreen({super.key});

  @override
  State<MusicTasteScreen> createState() => _MusicTasteScreenState();
}

class _MusicTasteScreenState extends State<MusicTasteScreen> {
  late Future<List<Track>> futureTracks;
  List<Track> tracks = [];
  bool initialized = false;
  bool finished = false;

  Map<String, int> genreCounter = {};

  void handleSwipe(Track track, bool liked) {
    if (liked) {
      for (final genre in track.genre) {
        genreCounter[genre] = (genreCounter[genre] ?? 0) + 1;
      }
    }
    setState(() {
      tracks.removeLast();
    });

    if (tracks.isEmpty) {
      debugPrint('All tracks swiped!');
      debugPrint('User genre taste: $genreCounter');
      finished = true;
    }
  }

  @override
  void initState() {
    super.initState();
    futureTracks = TrackApi.getRandomTracks();
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
              child: FutureBuilder<List<Track>>(
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
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (!initialized) {
                    tracks = List.from(snapshot.data!);
                    initialized = true;
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

  