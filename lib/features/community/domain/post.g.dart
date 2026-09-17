// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: json['id'] as String,
  authorName: json['authorName'] as String,
  authorAvatar: json['authorAvatar'] as String?,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
  isLikedByMe: json['isLikedByMe'] as bool? ?? false,
  commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'authorName': instance.authorName,
  'authorAvatar': instance.authorAvatar,
  'content': instance.content,
  'createdAt': instance.createdAt.toIso8601String(),
  'likesCount': instance.likesCount,
  'isLikedByMe': instance.isLikedByMe,
  'commentsCount': instance.commentsCount,
};
