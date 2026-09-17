// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Challenge _$ChallengeFromJson(Map<String, dynamic> json) => _Challenge(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  rewardPoints: (json['rewardPoints'] as num?)?.toInt() ?? 0,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  isJoined: json['isJoined'] as bool? ?? false,
);

Map<String, dynamic> _$ChallengeToJson(_Challenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'rewardPoints': instance.rewardPoints,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'isJoined': instance.isJoined,
    };
