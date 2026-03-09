import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/swipe_card.dart';
import '../widgets/swipeable_card.dart';
import '../widgets/music_taste_result.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../widgets/card_actions.dart';

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
  String? userId;
  Map<String, int> genreCounter = {};

  void handleSwipe(Track track, bool liked) async {
    if (userId == null) {
      debugPrint("User not loaded yet");
      return;
    }
    try {
      if (liked) {
        await ServiceLocator.interactionService.likeTrack(userId!, track.id);
      } else {
        await ServiceLocator.interactionService.dislikeTrack(userId!, track.id);
      }
    } catch (e) {
      debugPrint("Swipe save failed: $e");
    }

    if (liked) {
      for (final genre in track.genre) {
        genreCounter[genre] = (genreCounter[genre] ?? 0) + 1;
      }
    }

    setState(() {
      if (tracks.isNotEmpty) tracks.removeLast();
    });
    if (tracks.length <= fetchThreshold) {
      fetchMoreTracks();
    }
    // if (tracks.isEmpty && !isFetchingMore) {
    //   debugPrint('All tracks swiped!');
    //   debugPrint('User genre taste: $genreCounter');

    //   try {
    //     await ServiceLocator.musicRepository.saveUserTaste(genreCounter);
    //     debugPrint("Taste saved");
    //   } catch (e) {
    //     debugPrint("Taste save failed: $e");
    //   }

    //   setState(() => finished = true);
    // }
  }

  @override
  void initState() {
    super.initState();
    futureTracks = ServiceLocator.musicRepository.getRandomTracks();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await ServiceLocator.userRepository.me();
    setState(() {
      userId = user?.userId;
    });
  }

  Track _convertModelToTrack(TrackModel m) {
    final artist = m.artist.isNotEmpty ? m.artist.split(',')[0].trim() : '';
    final genres = m.genre.isNotEmpty
        ? m.genre.split(',').map((g) => g.trim()).toList()
        : <String>[];

    return Track(
      id: m.id,
      title: m.name,
      artist: artist.isNotEmpty ? artist : 'Unknown',
      image: m.imageUrl,
      genre: genres,
      description: '',
      duration: m.duration ?? '',
    );
  }

  bool isFetchingMore = false;
  static const int fetchThreshold = 10;

  Future<void> fetchMoreTracks() async {
    if (isFetchingMore) return;

    isFetchingMore = true;

    try {
      final newTracks = await ServiceLocator.musicRepository.getRandomTracks();

      setState(() {
        tracks.insertAll(0, newTracks.map((m) => _convertModelToTrack(m)));
      });
    } catch (e) {
      debugPrint("Fetch more tracks failed: $e");
    }

    isFetchingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120914),
      body: SafeArea(
        child: Column(
          children: [
            // const MusicTasteAppBar(),
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
                    tracks = snapshot.data!
                        .map((m) => _convertModelToTrack(m))
                        .toList();
                    initialized = true;
                  }

                  if (tracks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Stack(
                    children: [
                      
                      Stack(
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
                              onLike: () {},
                              onDislike: () {},
                            ),
                          );
                        }).toList(),
                      ),

                      /// ปุ่ม fixed ด้านล่าง
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: CardActions(
                          onLike: () {
                            final track = tracks.last;
                            handleSwipe(track, true);
                          },
                          onDislike: () {
                            final track = tracks.last;
                            handleSwipe(track, false);
                          },
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
