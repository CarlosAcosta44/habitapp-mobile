import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge.freezed.dart';
part 'challenge.g.dart';

@freezed
abstract class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String title,
    required String description,
    @Default(0) int rewardPoints,
    required DateTime expiresAt,
    @Default(false) bool isJoined,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
}
