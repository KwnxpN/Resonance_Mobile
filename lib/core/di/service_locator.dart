import '../../core/network/dio_client.dart';
import '../../features/musics/services/music_api_service.dart';
import '../../features/musics/repositories/music_repository.dart';

class ServiceLocator {
  static late final DioClient dioClient;
  static late final MusicApiService musicApiService;
  static late final MusicRepository musicRepository;

  static void init() {
    dioClient = DioClient();
    musicApiService = MusicApiService(dioClient);
    musicRepository = MusicRepository(musicApiService);
  }
}