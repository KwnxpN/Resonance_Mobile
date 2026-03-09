import 'package:dio/dio.dart';
import '../../features/musics/services/music_api_service.dart';
import '../../features/musics/repositories/music_repository.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/users/repositories/user_repository.dart';
import '../../features/users/services/user_service.dart';
import '../../core/network/auth_dio.dart';
import '../../core/network/music_dio.dart';
import '../../core/network/user_dio.dart';
import '../../core/player/player_controller.dart';

class ServiceLocator {
  static late final Dio authDio;
  static late final Dio musicDio;
  static late final Dio userDio;
  static late final MusicApiService musicApiService;
  static late final MusicRepository musicRepository;
  static late final AuthRepository authRepository;
  static late final UserRepository userRepository;

  static late final PlayerController playerController;
  static void init() {
    authDio = AuthDio.create();
    musicDio = MusicDio.create();
    userDio = UserDio.create();

    musicApiService = MusicApiService(musicDio);
    musicRepository = MusicRepository(musicApiService);
    playerController = PlayerController(musicRepository);

    authRepository = AuthRepository(AuthApiService(authDio));
    userRepository = UserRepository(UserApiService(userDio));
  }
}
