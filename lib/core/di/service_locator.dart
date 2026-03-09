import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../features/musics/services/music_api_service.dart';
import '../../features/musics/repositories/music_repository.dart';
import '../../features/musics/services/jamendo_service.dart';
import '../../features/musics/services/soundcloud_service.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/users/repositories/user_repository.dart';
import '../../features/users/services/user_service.dart';
import '../../core/network/auth_dio.dart';
import '../../core/network/music_dio.dart';
import '../../core/network/user_dio.dart';

class ServiceLocator {
  static late final Dio authDio;
  static late final Dio musicDio;
  static late final Dio userDio;
  static late final DioClient dioClient;
  static late final MusicApiService musicApiService;
  static late final MusicRepository musicRepository;
  static late final JamendoService jamendoService;
  static late final SoundCloudService soundcloudService;
  static late final AuthRepository authRepository;
  static late final UserRepository userRepository;

  static void init() {
    dioClient = DioClient();
    authDio = AuthDio.create();
    musicDio = MusicDio.create();
    userDio = UserDio.create();

    musicApiService = MusicApiService(musicDio);
    musicRepository = MusicRepository(musicApiService);
    jamendoService = JamendoService();
    soundcloudService = SoundCloudService();

    authRepository = AuthRepository(AuthApiService(authDio));
    userRepository = UserRepository(UserApiService(userDio));
  }
}
