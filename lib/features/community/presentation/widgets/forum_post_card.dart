import 'package:flutter/material.dart';
import '../../data/models/community_feed_models.dart';

const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);
const _kPink = Color(0xFFE22D6F);

class ForumPostCard extends StatelessWidget {
  final ForumPostItem post;
  final VoidCallback onToggleLike;
  final VoidCallback onParticipate;

  const ForumPostCard({
    super.key,
    required this.post,
    required this.onToggleLike,
    required this.onParticipate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFF2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header
          Row(
            children: [
              // Initials avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: post.avatarColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  post.authorInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name and time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: _kTextDark,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      post.timeAgo,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Category tag pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBF2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  post.tag,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: _kPink,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Question Title
          Text(
            post.questionTitle,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: _kTextDark,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 6),

          // Content body
          Text(
            post.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: _kTextGrey,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 14),

          // Footer: comments, likes, and participate button
          Row(
            children: [
              // Comments count
              Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 15,
                    color: _kTextGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.commentsCount} respuestas',
                    style: const TextStyle(
                      fontSize: 11,
                      color: _kTextGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Likes / Apoyos count (interactive toggle)
              GestureDetector(
                onTap: onToggleLike,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(
                      post.isLikedByMe
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16,
                      color: post.isLikedByMe ? _kPink : _kTextGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likesCount} apoyos',
                      style: TextStyle(
                        fontSize: 11,
                        color: post.isLikedByMe ? _kPink : _kTextGrey,
                        fontWeight:
                            post.isLikedByMe ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Participate button
              GestureDetector(
                onTap: onParticipate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Participar',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: _kTextDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
