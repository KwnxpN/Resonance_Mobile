import 'package:flutter/material.dart';
import '../core/di/service_locator.dart';
import '../features/musics/models/music_model.dart';
import '../features/playlists/models/playlist.dart';
import '../widgets/home_widgets/recommended_section.dart';
import '../widgets/home_widgets/trending_section.dart';
import '../widgets/home_widgets/playlist_section.dart';
import '../widgets/home_widgets/recommended_playlist_section.dart';
import '../widgets/home_widgets/create_playlist_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<TrackModel>> _recommendedTracksFuture;
  late Future<List<TrackModel>> _trendingTracksFuture;
  late Future<List<PlaylistModel>> _playlistsFuture;
  late Future<PlaylistModel> _recommendedPlaylistsFuture;
  late final Future<dynamic> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = ServiceLocator.userRepository.me();
    _recommendedTracksFuture =
        ServiceLocator.musicRepository.getTracks(query: {'limit': 30});
    _trendingTracksFuture =
        ServiceLocator.musicRepository.getRandomTracks();
    _playlistsFuture = _fetchPlaylists();
    _recommendedPlaylistsFuture = _fetchRecommendedPlaylist();
  }

  Future<List<PlaylistModel>> _fetchPlaylists() async {
    final user = await _userFuture;
    if (user == null) return [];
    return ServiceLocator.playlistRepository.getPersonalPlaylists(user.userId);
  }

  Future<PlaylistModel> _fetchRecommendedPlaylist() async {
    final user = await _userFuture;
    if (user == null) return PlaylistModel(id: '', userId: '', name: '', tracks: []);
    return ServiceLocator.playlistRepository
        .getRecommendedPlaylist(user.userId);
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

  void _retryRecommendedPlaylists() {
    setState(() {
      _recommendedPlaylistsFuture = _fetchRecommendedPlaylist();
    });
  }

  Future<void> _showCreatePlaylistSheet() async {
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreatePlaylistSheet(),
    );
    if (name == null || name.trim().isEmpty) return;
    final user = await _userFuture;
    if (user == null) return;
    final success = await ServiceLocator.playlistRepository
        .createPlaylist(user.userId, name.trim());
    if (success && mounted) _retryPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 16),
          RepaintBoundary(
            child: RecommendedSection(
              future: _recommendedTracksFuture,
              onRetry: _retryRecommended,
              onReturn: _retryPlaylists,
            ),
          ),
          const SizedBox(height: 24),
          RepaintBoundary(
            child: TrendingSection(
              future: _trendingTracksFuture,
              onRetry: _retryTrending,
              onReturn: _retryPlaylists,
            ),
          ),
          const SizedBox(height: 24),
          RepaintBoundary(
            child: RecommendedPlaylistSection(
              future: _recommendedPlaylistsFuture,
              onRetry: _retryRecommendedPlaylists,
              onReturn: _retryRecommendedPlaylists,
            ),
          ),
          const SizedBox(height: 24),
          RepaintBoundary(
            child: PlaylistSection(
              future: _playlistsFuture,
              onRetry: _retryPlaylists,
              onReturn: _retryPlaylists,
              onCreate: _showCreatePlaylistSheet,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
