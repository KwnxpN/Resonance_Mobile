class TrackModel {
  final String id;
  final String name;
  final String imageUrl;
  final String artist;
  final String genre;
  final String? duration;
  final String? audioUrl;

  TrackModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artist,
    required this.genre,
    this.duration,
    this.audioUrl,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      artist: json['artist'] as String,
      genre: json['genre'] as String,
      duration: json['duration'] as String?,
      audioUrl: json['audio_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'artist': artist,
      'genre': genre,
      'duration': duration,
      'audio_url': audioUrl,
    };
  }
}
