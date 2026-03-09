import '../../../models/track.dart';
import '../../features/musics/models/music_model.dart';

class TrackMapper {
  static Track fromModel(TrackModel m) {
    final artist = m.artist.split(',').first.trim();

    final genres = m.genre.isEmpty
        ? <String>[]
        : m.genre.split(',').map((g) => g.trim()).toList();

    return Track(
      id: m.id,
      title: m.name,
      artist: artist.isEmpty ? 'Unknown' : artist,
      image: m.imageUrl,
      genre: genres,
      description: '',
      duration: m.duration ?? '',
    );
  }

  static List<Track> fromModelList(List<TrackModel> models) {
    return models.map(fromModel).toList();
  }
}