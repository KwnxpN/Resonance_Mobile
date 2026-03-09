import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../features/playlists/models/playlist.dart';
import '../widgets/home_widgets/track_image_card.dart';
import '../widgets/home_widgets/playlist_card.dart';
import '../widgets/song_card.dart';
import './music_playback_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<TrackModel>> _recommendedTracksFuture;
  late Future<List<TrackModel>> _trendingTracksFuture;
  late Future<List<PersonalPlaylistModel>> _playlistsFuture;

  @override
  void initState() {
    super.initState();
    _recommendedTracksFuture =
        ServiceLocator.musicRepository.getTracks(query: {'limit': 30});
    _trendingTracksFuture =
        ServiceLocator.musicRepository.getRandomTracks();
    _playlistsFuture = _fetchPlaylists();
  }

  Future<List<PersonalPlaylistModel>> _fetchPlaylists() async {
    final user = await ServiceLocator.userRepository.me();
    if (user == null) return [];
    return ServiceLocator.playlistRepository.getPersonalPlaylists(user.userId);
  }

  void _retryRecommended() {
    setState(() {
      _recommendedTracksFuture =
          ServiceLocator.musicRepository.getTracks(query: {'limit': 30});
    });
  }

  void _retryTrending() {
    setState(() {
      _trendingTracksFuture =
          ServiceLocator.musicRepository.getRandomTracks();
    });
  }

  void _retryPlaylists() {
    setState(() {
      _playlistsFuture = _fetchPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _RecommendedSection(
            future: _recommendedTracksFuture,
            onRetry: _retryRecommended,
            onReturn: _retryPlaylists,
          ),
          const SizedBox(height: 24),
          _TrendingSection(
            future: _trendingTracksFuture,
            onRetry: _retryTrending,
            onReturn: _retryPlaylists,
          ),
          const SizedBox(height: 24),
          _PlaylistSection(
            future: _playlistsFuture,
            onRetry: _retryPlaylists,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Recommended section ──────────────────────────────────────────────────────

class _RecommendedSection extends StatelessWidget {
  final Future<List<TrackModel>> future;
  final VoidCallback onRetry;
  final VoidCallback onReturn;

  const _RecommendedSection({
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
              return _SectionError(
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
                  final endIndex =
                      (startIndex + pageSize).clamp(0, tracks.length);
                  final pageItems = tracks.sublist(startIndex, endIndex);

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => MusicPlaybackScreen(
                                tracks: tracks,
                                initialIndex: globalIndex,
                              ),
                            ),
                          ).then((_) => onReturn());
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

// ── Trending section ─────────────────────────────────────────────────────────

class _TrendingSection extends StatelessWidget {
  final Future<List<TrackModel>> future;
  final VoidCallback onRetry;
  final VoidCallback onReturn;

  const _TrendingSection({
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
              return _SectionError(
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
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) => MusicPlaybackScreen(
                                  tracks: tracks,
                                  initialIndex: globalIndex,
                                ),
                              ),
                            ).then((_) => onReturn());
                          },
                          onMoreTap: () {},
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

// ── Playlist section ─────────────────────────────────────────────────────────

class _PlaylistSection extends StatelessWidget {
  final Future<List<PersonalPlaylistModel>> future;
  final VoidCallback onRetry;

  const _PlaylistSection({required this.future, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Your Playlists',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<PersonalPlaylistModel>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return _SectionError(
                message: 'Failed to load playlists',
                onRetry: onRetry,
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const _SectionError(message: 'No playlists yet');
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
                    PlaylistCard(playlist: playlists[index]),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── Shared error widget ───────────────────────────────────────────────────────

class _SectionError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _SectionError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(color: Colors.grey)),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
