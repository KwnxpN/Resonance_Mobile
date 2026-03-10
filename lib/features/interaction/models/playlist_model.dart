class PlaylistModel {
  final String id;
  final String userId;
  final String name;

  PlaylistModel({
    required this.id,
    required this.userId,
    required this.name,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
    );
  }
}