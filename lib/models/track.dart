class Track {
  final String title;
  final String artist;
  final String image;
  final List<String> tags;
  final String description;
  final String duration;

  Track({
    required this.title,
    required this.artist,
    required this.image,
    required this.tags,
    required this.description,
    required this.duration,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      image: json['image'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
  
}
