import 'package:dio/dio.dart';
import '../../features/musics/services/music_api_service.dart';
import '../../features/musics/repositories/music_repository.dart';
import '../../features/users/repositories/auth_repository.dart';
import '../../features/users/services/auth_service.dart';
import '../../core/network/auth_dio.dart';
import '../../core/network/music_dio.dart';

class ServiceLocator {
  static late final Dio authDio;
  static late final Dio musicDio;
  static late final MusicApiService musicApiService;
  static late final MusicRepository musicRepository;
  static late final AuthRepository authRepository;
  static void init() {
    authDio = AuthDio.create();
    musicDio = MusicDio.create();

    musicApiService = MusicApiService(musicDio);
    musicRepository = MusicRepository(musicApiService);

    final authApi = AuthApiService(authDio);
    authRepository = AuthRepository(authApi);
  }
}
