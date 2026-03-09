import 'package:dio/dio.dart';
import 'package:flutter_project/core/network/interaction_dio.dart';
import 'package:flutter_project/features/interaction/services/interaction_api_service.dart';
import '../../features/musics/services/music_api_service.dart';
import '../../features/musics/repositories/music_repository.dart';

import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/services/auth_service.dart';

import '../../features/users/repositories/user_repository.dart';
import '../../features/users/services/user_service.dart';

import '../../features/playlists/services/playlist_service.dart';
import '../../features/playlists/repositories/playlist_repository.dart';

import '../../features/swipes/services/swipe_service.dart';
import '../../features/swipes/repositories/swipe_repository.dart';

import '../../features/match/services/match_api_service.dart';
import '../../features/match/repositories/match_repository.dart';

import '../../core/network/auth_dio.dart';
import '../../core/network/music_dio.dart';
import '../../core/network/user_dio.dart';
import '../../core/player/player_controller.dart';

import '../../features/interaction/repositories/interaction_repository.dart';
import '../../core/network/match_dio.dart';

class ServiceLocator {
  static late final Dio authDio;
  static late final Dio musicDio;
  static late final Dio userDio;
  static late final Dio interactionDio;
  static late final MusicApiService musicApiService;
  static late final MusicRepository musicRepository;
  static late final Dio matchDio;

  static late final AuthRepository authRepository;
  static late final UserRepository userRepository;
  static late final InteractionRepository interactionRepository;
  static late final InteractionService interactionService;

  static late final PlaylistRepository playlistRepository;
  static late final SwipeRepository swipeRepository;

  static late final MatchApiService matchApiService;
  static late final MatchRepository matchRepository;

  static late final PlayerController playerController;
  static void init() {
    authDio = AuthDio.create();
    musicDio = MusicDio.create();
    userDio = UserDio.create();
    interactionDio = InteractionDio.create();
    matchDio = MatchDio.create();
    musicApiService = MusicApiService(musicDio);
    musicRepository = MusicRepository(musicApiService);
    playerController = PlayerController(musicRepository);

    authRepository = AuthRepository(AuthApiService(authDio));
    userRepository = UserRepository(UserApiService(userDio));
    interactionRepository = InteractionRepository();
    interactionService = InteractionService(interactionRepository);
    playlistRepository = PlaylistRepository(PlaylistApiService(interactionDio));
    swipeRepository = SwipeRepository(SwipeApiService(interactionDio));

    matchApiService = MatchApiService(matchDio);
    matchRepository = MatchRepository(matchApiService);
  }
}
