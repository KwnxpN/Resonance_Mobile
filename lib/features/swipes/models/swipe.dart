class SwipeModel {
  final String id;
  final String userId;
  final String trackId;
  final String action; // 'like' or 'dislike'
  final DateTime createdAt;

  SwipeModel({
    required this.id,
    required this.userId,
    required this.trackId,
    required this.action,
    required this.createdAt,
  });

  factory SwipeModel.fromJson(Map<String, dynamic> json) {
    return SwipeModel(
      id: json['ID'] ?? '',
      userId: json['UserID'] ?? '',
      trackId: json['TrackID'] ?? '',
      action: json['Action'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}