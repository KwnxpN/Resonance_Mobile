import 'package:flutter/material.dart';
import '../models/track.dart';
import '../widgets/music_taste_widgets/card/swipeable_card.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../widgets/music_taste_widgets/card/card_actions.dart';
import '../widgets/music_taste_widgets/track_card_stack.dart';
import '../widgets/music_taste_widgets/track_mapper.dart';

class MusicTasteScreen extends StatefulWidget {
  const MusicTasteScreen({super.key});

  @override
  State<MusicTasteScreen> createState() => _MusicTasteScreenState();
}

class _MusicTasteScreenState extends State<MusicTasteScreen> {
  GlobalKey<SwipeableCardState> swipeKey = GlobalKey();
  late Future<List<TrackModel>> futureTracks;


  List<Track> tracks = [];
  bool initialized = false;

  String? userId;
  final Map<String, int> genreCounter = {};

  bool isFetchingMore = false;
  static const int fetchThreshold = 10;

  @override
  void initState() {
    super.initState();
    futureTracks = ServiceLocator.musicRepository.getRandomTracks();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await ServiceLocator.userRepository.me();
    if (!mounted) return;

    setState(() {
      userId = user?.userId;
    });
  }

  Future<void> handleSwipe(Track track, bool liked) async {
    if (userId == null) return;

    try {
      final service = ServiceLocator.interactionService;

      if (liked) {
        await service.likeTrack(userId!, track.id);
      } else {
        await service.dislikeTrack(userId!, track.id);
      }
    } catch (e) {
      debugPrint("Swipe save failed: $e");
    }

    if (liked) {
      for (final genre in track.genre) {
        genreCounter.update(genre, (v) => v + 1, ifAbsent: () => 1);
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

  Future<void> fetchMoreTracks() async {
    if (isFetchingMore) return;
    isFetchingMore = true;

    try {
      final newTracks = await ServiceLocator.musicRepository.getRandomTracks();

      if (!mounted) return;

      setState(() {
        tracks.addAll(TrackMapper.fromModelList(newTracks));
      });
    } catch (e) {
      debugPrint("Fetch more tracks failed: $e");
    } finally {
      isFetchingMore = false;
    }
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError() {
    return const Center(
      child: Text(
        'Failed to load tracks',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120914),
      body: SafeArea(
        child: FutureBuilder<List<TrackModel>>(
          future: futureTracks,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return _buildLoading();
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return _buildError();
            }

            if (!initialized) {
              tracks = TrackMapper.fromModelList(snapshot.data!);
              initialized = true;
            }

            if (tracks.isEmpty) return _buildLoading();

            return Stack(
              clipBehavior: Clip.none,
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
                    onLike: () => swipeKey.currentState?.swipeRight(),
                    onDislike: () => swipeKey.currentState?.swipeLeft(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}