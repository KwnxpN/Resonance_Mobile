import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/music_taste_widgets/card/swipeable_card.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../widgets/music_taste_widgets/card/card_actions.dart';
import '../widgets/music_taste_widgets/track_card_stack.dart';

class MusicTasteScreen extends StatefulWidget {
  const MusicTasteScreen({super.key});

  @override
  State<MusicTasteScreen> createState() => _MusicTasteScreenState();
}

class _MusicTasteScreenState extends State<MusicTasteScreen> {
  late GlobalKey<SwipeableCardState> swipeKey = GlobalKey();
  late Future<List<TrackModel>> futureTracks;
  List<Track> tracks = [];
  bool initialized = false;
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
      swipeKey = GlobalKey();
    });
    if (tracks.length <= fetchThreshold) {
      fetchMoreTracks();
    }
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
            Expanded(
              child: FutureBuilder<List<TrackModel>>(
                future: futureTracks,
                builder: (context, snapshot) {
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
                      TrackCardStack(
                        tracks: tracks,
                        swipeKey: swipeKey,
                        onSwipe: handleSwipe,
                      ),
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: CardActions(
                          onLike: () {
                            swipeKey.currentState?.swipeRight();
                          },

                          onDislike: () {
                            swipeKey.currentState?.swipeLeft();
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
