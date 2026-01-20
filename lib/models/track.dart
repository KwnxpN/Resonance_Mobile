class Track {
  final String title;
  final String artist;
  final String image;
  final List<String> genre;
  final String description;
  final String duration;

  Track({
    required this.title,
    required this.artist,
    required this.image,
    required this.genre,
    required this.description,
    required this.duration,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      image: json['image'] ?? '',
      genre: List<String>.from(json['genre'] ?? []),
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
  
}
