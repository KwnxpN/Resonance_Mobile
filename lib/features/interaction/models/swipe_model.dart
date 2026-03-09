class SwipeModel {
  final String id;
  final String userId;
  final String trackId;
  final String action;
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
      id: json['id'],
      userId: json['userId'],
      trackId: json['trackId'],
      action: json['action'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "trackId": trackId,
      "action": action,
    };
  }
}