import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/swipe_card.dart';
import '../widgets/music_taste_app_bar.dart';
import '../widgets/swipeable_card.dart';
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

  List<Track> tracks = [];
  bool initialized = false;

  Map<String, int> genreCounter = {};

  @override
  void initState() {
    super.initState();
    futureTracks = ServiceLocator.musicRepository.getRandomTracks();
  }

  void handleSwipe(Track track, bool liked) async {
    if (liked) {
      for (final genre in track.genre) {
        genreCounter[genre] = (genreCounter[genre] ?? 0) + 1;
      }
    }

    setState(() {
      tracks.removeLast();
    });

    if (tracks.isEmpty) {
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
        child: Stack(
          children: [
            /// 🔥 เนื้อหาหลัก
            Positioned.fill(
              child: Column(
                children: [
                  const MusicTasteAppBar(),
                  Expanded(
                    child: FutureBuilder<List<TrackModel>>(
                      future: futureTracks,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'Failed to load tracks',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        if (!initialized) {
                          tracks = snapshot.data!
                              .map(_convertModelToTrack)
                              .toList();
                          initialized = true;
                        }

                        if (tracks.isEmpty) {
                          return const SizedBox();
                        }

                        return Stack(
                          alignment: Alignment.center,
                          children: tracks.asMap().entries.map((entry) {
                            final index = entry.key;
                            final track = entry.value;

                            if (index == tracks.length - 1) {
                              return SwipeableCard(
                                track: track,
                                onLike: () => handleSwipe(track, true),
                                onDislike: () => handleSwipe(track, false),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: SwipeCard(
                                track: track,
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

            /// 🔥 ปุ่มลอยติดล่างจอ
            Positioned(
              left: 24,
              right: 24,
              bottom: 30,
              child: CardActions(
                onLike: () {
                  if (tracks.isNotEmpty) {
                    handleSwipe(tracks.last, true);
                  }
                },
                onDislike: () {
                  if (tracks.isNotEmpty) {
                    handleSwipe(tracks.last, false);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}