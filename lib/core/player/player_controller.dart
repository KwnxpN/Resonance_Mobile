import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../features/musics/models/music_model.dart';
import '../../features/musics/repositories/music_repository.dart';

class PlayerController extends ChangeNotifier {
  final MusicRepository _musicRepository;
  final AudioPlayer player = AudioPlayer();

  List<TrackModel> trackList = [];
  int currentIndex = 0;

  String songName = '';
  String artistName = '';
  String imageUrl = '';
  bool isLoading = false;
  bool hasTrack = false;

  StreamSubscription<PlayerState>? _completionSubscription;

  PlayerController(this._musicRepository) {
    _completionSubscription = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  Future<void> loadTracks(List<TrackModel> tracks, int index) async {
    // Same session already active — don't restart, just re-attach UI
    if (identical(trackList, tracks) && currentIndex == index && hasTrack) {
      return;
    }
    trackList = tracks;
    await playTrackAtIndex(index);
  }

  Future<void> playTrackAtIndex(int index) async {
    if (index < 0 || index >= trackList.length) return;

    currentIndex = index;
    isLoading = true;
    hasTrack = true;

    final preview = trackList[index];
    songName = preview.name;
    artistName = preview.artist;
    imageUrl = preview.imageUrl;
    notifyListeners();

    try {
      final track = await _musicRepository.getTrackById(preview.id);

      if (track.audioUrl == null || track.audioUrl!.isEmpty) {
        throw Exception('No audio URL for this track');
      }

      await player.setUrl(track.audioUrl!);
      isLoading = false;
      notifyListeners();
      await player.play();
    } catch (e) {
      debugPrint('PlayerController: failed to play track: $e');
      isLoading = false;
      songName = 'Error loading song';
      artistName = '';
      imageUrl = '';
      notifyListeners();
    }
  }

  void playNext() {
    if (currentIndex < trackList.length - 1) {
      playTrackAtIndex(currentIndex + 1);
    } else {
      playTrackAtIndex(0);
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      playTrackAtIndex(currentIndex - 1);
    } else {
      playTrackAtIndex(trackList.length - 1);
    }
  }

  @override
  void dispose() {
    _completionSubscription?.cancel();
    player.dispose();
    super.dispose();
  }
}
