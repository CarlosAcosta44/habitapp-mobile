import 'package:flutter/material.dart';
import 'time_formatter.dart';
import '../../data/models/community_feed_models.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPostItem post;
  final VoidCallback onToggleLike;
  final VoidCallback onParticipate;
  final VoidCallback? onTap;
  final String? currentUserId;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ForumPostCard({
    super.key,
    required this.post,
    required this.onToggleLike,
    required this.onParticipate,
    this.onTap,
    this.currentUserId,
    this.onEdit,
    this.onDelete,
  });

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar foro'),
              onTap: () {
                Navigator.pop(ctx);
                onEdit?.call();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar foro', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                onDelete?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap ?? onParticipate,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, Time, Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Author Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xFF6B4EFF).withValues(alpha: 0.1),
                      backgroundImage: post.authorAvatarUrl.isNotEmpty ? NetworkImage(post.authorAvatarUrl) : null,
                      child: post.authorAvatarUrl.isEmpty
                          ? Text(
                              post.authorInitials,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6B4EFF)),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                // Time & Tag & Menu
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          post.fechacreacion != null ? timeAgo(post.fechacreacion!) : post.timeAgo,
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (currentUserId != null && currentUserId == post.authorId)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.more_vert, size: 18, color: colorScheme.onSurfaceVariant),
                        onPressed: () => _showOptionsMenu(context),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question Title
            Text(
              post.questionTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // Content body
            Text(
              post.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Footer: comments, likes, and participate button
            Row(
              children: [
                // Likes
                GestureDetector(
                  onTap: onToggleLike,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Icon(
                        post.isLikedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 14,
                        color: post.isLikedByMe ? const Color(0xFFE22D6F) : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likesCount} apoyos',
                        style: TextStyle(
                          fontSize: 11,
                          color: post.isLikedByMe ? const Color(0xFFE22D6F) : Colors.grey[700],
                          fontWeight: post.isLikedByMe ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Comments
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${post.commentsCount} respuestas',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
