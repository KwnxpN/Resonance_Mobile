import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';
import '../widgets/artwork_image.dart';
import '../core/di/service_locator.dart';
import 'dart:async';

class MusicPlaybackScreen extends StatefulWidget {
  const MusicPlaybackScreen({super.key});

  @override
  _MusicPlaybackScreenState createState() => _MusicPlaybackScreenState();
}

class _MusicPlaybackScreenState extends State<MusicPlaybackScreen> {
  String _songName = 'Song Title';
  String _artistName = 'Artist Name';
  String _imageURL = '';
  final _player = AudioPlayer();
  bool _isLoading = false;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  List<dynamic> _trackList = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTracks();
    _setupPlayerListener();
  }

  Future<void> _loadTracks() async {
    setState(() => _isLoading = true);

    try {
      final trackList = await ServiceLocator.musicRepository.getRandomTracks();

      if (!mounted) return;

      if (trackList.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _trackList = trackList;
        _currentIndex = 0;
      });

      await _playTrackAtIndex(0);
    } catch (e, stackTrace) {
      debugPrint('Failed to load tracks: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _songName = 'Error loading songs';
        _artistName = '';
        _imageURL = '';
      });
    }
  }

  Future<void> _playTrackAtIndex(int index) async {
    if (index < 0 || index >= _trackList.length) return;

    setState(() {
      _isLoading = true;
      _currentIndex = index;
    });

    try {
      final track = _trackList[index];

      setState(() {
        _songName = track.name;
        _artistName = track.artists.first;
        _imageURL = track.imageUrl;
      });

      final audioUrl = await ServiceLocator.jamendoService.findTrackAudio(
        track.name,
        track.artists.first,
      );

      if (audioUrl == null) {
        throw Exception('No audio found on Jamendo');
      }

      await _player.setUrl(audioUrl);

      if (mounted) {
        setState(() => _isLoading = false);
        await _player.play();
      }
    } catch (e) {
      debugPrint('Failed to play track: $e');

      if (!mounted) return;

      await _player.stop();

      setState(() {
        _isLoading = false;
        _songName = 'Error loading song';
        _artistName = '';
        _imageURL = '';
      });
    }
  }

  void _setupPlayerListener() {
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _playNext();
      }
    });

    // Listen for ready state to hide loading
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.ready &&
          playerState.playing) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    });
  }

  void _playNext() {
    if (_currentIndex < _trackList.length - 1) {
      _playTrackAtIndex(_currentIndex + 1);
    } else {
      _playTrackAtIndex(0);
    }
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      _playTrackAtIndex(_currentIndex - 1);
    }
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              if (_isLoading) const LinearProgressIndicator(),
              // Header with close and more options buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: IconButton.styleFrom(
                      foregroundColor: colors.onBackground,
                      iconSize: 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  // Playlist title
                  Column(
                    children: [
                      Text(
                        'NOW PLAYING',
                        style: AppTextStyles.textXs(context).copyWith(
                          color: colors.muted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        _isLoading ? 'Loading...' : _songName,
                        style: AppTextStyles.textMd(context).copyWith(
                          color: colors.onBackground,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // More options button
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    style: IconButton.styleFrom(
                      foregroundColor: colors.onBackground,
                      iconSize: 28,
                    ),
                    onPressed: () {
                      // Handle more options action
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Music Artwork
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ArtworkImage(
                      imageUrl: _imageURL.isNotEmpty ? _imageURL : null,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Control Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      // Song title / Artist, add to playlist, favorite
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: // Song title and artist
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isLoading ? 'Loading...' : _songName,
                                  style: AppTextStyles.textXl(context).copyWith(
                                    color: colors.onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _isLoading ? 'Loading...' : _artistName,
                                  style: AppTextStyles.textMd(
                                    context,
                                  ).copyWith(color: colors.muted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Action buttons
                          Row(
                            children: [
                              // Add to playlist
                              IconButton(
                                icon: const Icon(Icons.playlist_add),
                                style: IconButton.styleFrom(
                                  foregroundColor: colors.onBackground,
                                  iconSize: 28,
                                ),
                                onPressed: () {
                                  // Handle add to playlist action
                                },
                              ),

                              // Favorite
                              IconButton(
                                icon: const Icon(Icons.favorite_border),
                                style: IconButton.styleFrom(
                                  foregroundColor: colors.onBackground,
                                  iconSize: 28,
                                ),
                                onPressed: () {
                                  // Handle favorite action
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Progress bar
                      StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (_, snapshot) {
                          return ProgressBar(
                            progress: snapshot.data ?? Duration.zero,
                            total: _player.duration ?? Duration.zero,
                            onSeek: _player.seek,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Playback controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Shuffle
                          // IconButton(
                          //   icon: const Icon(Icons.shuffle),
                          //   style: IconButton.styleFrom(
                          //     foregroundColor: colors.muted,
                          //     iconSize: 28,
                          //   ),
                          //   onPressed: () {
                          //     // Handle shuffle action
                          //   },
                          // ),

                          // Previous
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            style: IconButton.styleFrom(
                              foregroundColor: colors.onBackground,
                              iconSize: 36,
                            ),
                            onPressed: _isLoading || _currentIndex <= 0
                                ? null
                                : _playPrevious,
                          ),

                          // Play/Pause
                          StreamBuilder<PlayerState>(
                            stream: _player.playerStateStream,
                            builder: (context, snapshot) {
                              final playing = snapshot.data?.playing ?? false;

                              return IconButton(
                                icon: Icon(
                                  playing
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                ),
                                style: IconButton.styleFrom(
                                  foregroundColor: colors.onBackground,
                                  backgroundColor: colors.primary,
                                  iconSize: 64,
                                ),
                                onPressed: playing
                                    ? _player.pause
                                    : _player.play,
                              );
                            },
                          ),

                          // Next
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            style: IconButton.styleFrom(
                              foregroundColor: colors.onBackground,
                              iconSize: 36,
                            ),
                            onPressed:
                                _isLoading ||
                                    _currentIndex >= _trackList.length - 1
                                ? null
                                : _playNext,
                          ),

                          // Repeat
                          // IconButton(
                          //   icon: const Icon(Icons.repeat),
                          //   style: IconButton.styleFrom(
                          //     foregroundColor: colors.primary,
                          //     iconSize: 28,
                          //   ),
                          //   onPressed: () {
                          //     // Handle repeat action
                          //   },
                          // ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Friends Listening Counter and Lyrics Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Friends Listening Counter
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: colors.muted.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: colors.muted),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Friend avatars stack
                                SizedBox(
                                  width: 40,
                                  height: 24,
                                  child: Stack(
                                    children: [
                                      // Replace with actual friend avatars
                                      Positioned(
                                        left: 0,
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: colors.primary,
                                          child: Icon(
                                            Icons.person,
                                            size: 12,
                                            color: colors.onBackground,
                                          ),
                                        ),
                                      ),
                                      // Replace with actual friend avatars
                                      Positioned(
                                        left: 14,
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: colors.primary,
                                          child: Icon(
                                            Icons.person,
                                            size: 12,
                                            color: colors.onBackground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '12 Friends Listening',
                                  style: AppTextStyles.textSm(context).copyWith(
                                    color: colors.onBackground,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Lyrics Button
                          // IconButton(
                          //   icon: const Icon(Icons.lyrics),
                          //   onPressed: () {
                          //     // Handle lyrics action
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
