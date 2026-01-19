class TrackModel {
  final String id;
  final String name;
  final String imageUrl;
  final List artists;
  final List genres;
  // final DateTime releaseDate;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  TrackModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artists,
    required this.genres,
    // required this.releaseDate,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
      artists: (json['artists'] as List),
      genres: (json['genres'] as List),
      // releaseDate: DateTime.parse(json['release_date'] as String),
      // createdAt: DateTime.parse(json['created_at'] as String),
      // updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'artists': artists.map((artist) => artist.toJson()).toList(),
      'genres': genres.map((genre) => genre.toJson()).toList(),
      // 'release_date': releaseDate.toIso8601String(),
      // 'created_at': createdAt.toIso8601String(),
      // 'updated_at': updatedAt.toIso8601String(),
    };
  }
}
