class PlaylistModel {
  final String id;
  final String userId;
  final String name;
  final List<String> tracks;

  PlaylistModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.tracks,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['ID'] ?? '',
      userId: json['UserID'] ?? '',
      name: json['Name'] ?? '',
      tracks: List<String>.from(json['Track'] ?? []),
    );
  }
}