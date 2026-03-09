class MatchModel {
  final String matchId;
  final String userAId;
  final String userBId;

  MatchModel({
    required this.matchId,
    required this.userAId,
    required this.userBId,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['match_id'] as String,
      userAId: json['user_a_id'] as String,
      userBId: json['user_b_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'user_a_id': userAId,
      'user_b_id': userBId,
    };
  }
}
