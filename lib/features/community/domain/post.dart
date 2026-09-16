import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required String authorName,
    String? authorAvatar,
    required String content,
    required DateTime createdAt,
    @Default(0) int likesCount,
    @Default(false) bool isLikedByMe,
    @Default(0) int commentsCount,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
