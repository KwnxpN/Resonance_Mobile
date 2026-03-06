class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final String bio;
  final String avatarUrl;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.bio,
    required this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'] ?? '',
      bio: json['bio'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
