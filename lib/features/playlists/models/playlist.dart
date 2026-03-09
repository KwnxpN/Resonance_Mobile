class PersonalPlaylistModel {
  final String id;
  final String userId;
  final String name;
  final List<String> tracks;

  PersonalPlaylistModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.tracks,
  });

  factory PersonalPlaylistModel.fromJson(Map<String, dynamic> json) {
    return PersonalPlaylistModel(
      id: json['ID'] ?? '',
      userId: json['UserID'] ?? '',
      name: json['Name'] ?? '',
      tracks: List<String>.from(json['Track'] ?? []),
    );
  }
}