import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/community_provider.dart';
import '../../../profile/providers/profile_provider.dart';

import '../widgets/time_formatter.dart';

class ForumDetailScreen extends ConsumerStatefulWidget {
  final String forumId;
  final String title;

  const ForumDetailScreen({
    super.key,
    required this.forumId,
    required this.title,
  });

  @override
  ConsumerState<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends ConsumerState<ForumDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  
  String? _replyingToCommentId;
  String? _replyingToAuthorName;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingToCommentId = null;
      _replyingToAuthorName = null;
    });
  }

  void _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      String? imageUrl;
      if (_selectedImage != null) {
        // We will call the provider to upload the image
        imageUrl = await ref.read(forumCommentsProvider(widget.forumId).notifier).uploadImage(_selectedImage!.path);
      }

      await ref
          .read(forumCommentsProvider(widget.forumId).notifier)
          .addComment(widget.forumId, text, imagenUrl: imageUrl, parentId: _replyingToCommentId);
      
      if (mounted) {
        _commentController.clear();
        _removeImage();
        _cancelReply();
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar comentario: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);
    final commentsAsync = ref.watch(forumCommentsProvider(widget.forumId));
    final forumsAsync = ref.watch(forumsProvider);
    final forum = forumsAsync.value?.firstWhere(
      (f) => f['idforo'] == widget.forumId,
      orElse: () => null,
    );

    final authorName = forum != null && forum['usuarios'] != null
        ? '${forum['usuarios']['nombre'] ?? ''} ${forum['usuarios']['apellido'] ?? ''}'.trim()
        : 'Usuario';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo-habitapp.png',
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.forum_rounded, color: Color(0xFF6B4EFF), size: 20),
            ),
            const SizedBox(width: 8),
            const Text('Detalle De Foro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF6B4EFF).withValues(alpha: 0.1),
              backgroundImage: profileState.value?.fotoperfil != null && profileState.value!.fotoperfil!.isNotEmpty
                  ? NetworkImage(profileState.value!.fotoperfil!)
                  : null,
              child: profileState.value?.fotoperfil == null || profileState.value!.fotoperfil!.isEmpty
                  ? Text(
                      profileState.value?.nombre.isNotEmpty == true ? profileState.value!.nombre[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6B4EFF)),
                    )
                  : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (forum != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6B4EFF).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  forum['categoria'] != null ? '#${forum['categoria']}' : '#Comunidad',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6B4EFF),
                                  ),
                                ),
                              ),
                              if (profileState.value?.idusuario != null && profileState.value?.idusuario == forum['idusuario'])
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                                  onPressed: () {
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
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('La edición estará disponible pronto.')),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.delete, color: Colors.red),
                                              title: const Text('Eliminar foro', style: TextStyle(color: Colors.red)),
                                              onTap: () async {
                                                Navigator.pop(ctx);
                                                final confirm = await showDialog<bool>(
                                                  context: context,
                                                  builder: (c) => AlertDialog(
                                                    title: const Text('Eliminar Foro'),
                                                    content: const Text('¿Estás seguro de eliminar este foro? Esta acción no se puede deshacer.'),
                                                    actions: [
                                                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
                                                      TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
                                                    ],
                                                  ),
                                                );
                                                if (confirm == true) {
                                                  try {
                                                    await ref.read(forumsProvider.notifier).deleteForum(widget.forumId);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foro eliminado')));
                                                      Navigator.pop(context);
                                                    }
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            forum['titulo'] ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFF6B4EFF).withValues(alpha: 0.1),
                                backgroundImage: forum['usuarios']?['fotoperfil'] != null
                                    ? NetworkImage(forum['usuarios']['fotoperfil'])
                                    : null,
                                child: forum['usuarios']?['fotoperfil'] == null
                                    ? Text(
                                        authorName.isNotEmpty ? authorName[0].toUpperCase() : 'U',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6B4EFF)),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName.isEmpty ? 'Usuario' : authorName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    '${timeAgo(forum['fechacreacion'] ?? '')} · ${forum['usuarios']?['nombrerol'] ?? 'Usuario'}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            forum['descripcion'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ref.read(forumsProvider.notifier).toggleLike(widget.forumId);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        (forum['liked_by_me'] == true) ? Icons.favorite : Icons.favorite_border,
                                        size: 16, 
                                        color: (forum['liked_by_me'] == true) ? Colors.red : Colors.grey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${forum['likes_count'] ?? 0}', 
                                        style: TextStyle(
                                          color: (forum['liked_by_me'] == true) ? Colors.red : Colors.grey[700], 
                                          fontSize: 13, 
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    commentsAsync.when(
                                      data: (comments) => Text('${comments.length}', style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.bold)),
                                      loading: () => const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2)),
                                      error: (err, stack) => const Text('0'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(height: 1, thickness: 1),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Respuestas de la Comunidad',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Más recientes',
                                style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                commentsAsync.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text('Sé el primero en comentar.')),
                        ),
                      );
                    }
                    
                    final topLevelComments = comments.where((c) => c['idcomentario_padre'] == null).toList();
                    
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildCommentNode(context, topLevelComments[index], comments, theme, 0);
                          },
                          childCount: topLevelComments.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                  error: (e, _) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
          
          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_replyingToAuthorName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Respondiendo a $_replyingToAuthorName', style: const TextStyle(fontSize: 12, color: Color(0xFF6B4EFF), fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: _cancelReply,
                            child: const Icon(Icons.close, size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  if (_selectedImage != null)
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_selectedImage!, height: 80, width: 80, fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.white, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _removeImage,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: const Icon(Icons.image_outlined, color: Color(0xFF6B4EFF), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Escribe una respuesta o consejo.',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: const TextStyle(fontSize: 13),
                          maxLines: null,
                          enabled: !_isUploading,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _isUploading ? null : _submitComment,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _isUploading ? Colors.grey : const Color(0xFF6B4EFF),
                            shape: BoxShape.circle,
                          ),
                          child: _isUploading 
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentNode(BuildContext context, Map<String, dynamic> comment, List<dynamic> allComments, ThemeData theme, int depth, [String? parentAuthorName]) {
    final commentAuthorName = comment['usuarios'] != null
        ? '${comment['usuarios']['nombre'] ?? ''} ${comment['usuarios']['apellido'] ?? ''}'.trim()
        : 'Usuario';
    
    final children = allComments.where((c) => c['idcomentario_padre'] == comment['idcomentario']).toList();
    final profileState = ref.read(profileProvider);

    return Container(
      margin: depth == 0 ? const EdgeInsets.only(bottom: 16) : const EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(depth == 0 ? 16 : 12),
      decoration: BoxDecoration(
        color: depth == 0 ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: depth == 0 ? Border.all(color: Colors.grey.withValues(alpha: 0.2)) : null,
        boxShadow: depth == 0 ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (depth > 1 && parentAuthorName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.reply, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Respondió a $parentAuthorName',
                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF6B4EFF).withValues(alpha: 0.1),
                    backgroundImage: comment['usuarios']?['fotoperfil'] != null
                        ? NetworkImage(comment['usuarios']['fotoperfil'])
                        : null,
                    child: comment['usuarios']?['fotoperfil'] == null
                        ? Text(commentAuthorName.isNotEmpty ? commentAuthorName[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6B4EFF)))
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            commentAuthorName.isEmpty ? 'Usuario' : commentAuthorName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    timeAgo(comment['fechapublicacion'] ?? ''),
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                  if (profileState.value?.idusuario != null && profileState.value?.idusuario == comment['idusuario'])
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[500]),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La edición estará disponible pronto.')));
                        }
                        if (value == 'delete') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Eliminar Comentario'),
                              content: const Text('¿Estás seguro de eliminar este comentario? Esta acción no se puede deshacer.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
                                TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            try {
                              await ref.read(forumCommentsProvider(widget.forumId).notifier).deleteComment(widget.forumId, comment['idcomentario']);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comentario eliminado')));
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            }
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [Icon(Icons.edit, size: 14), SizedBox(width: 8), Text('Editar', style: TextStyle(fontSize: 13))]),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [Icon(Icons.delete, size: 14, color: Colors.red), SizedBox(width: 8), Text('Eliminar', style: TextStyle(fontSize: 13, color: Colors.red))]),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (comment['imagen_url'] != null && comment['imagen_url'].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  comment['imagen_url'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
          Text(
            comment['contenido'] ?? '',
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(forumCommentsProvider(widget.forumId).notifier).toggleLike(widget.forumId, comment['idcomentario']);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        (comment['liked_by_me'] == true) ? Icons.favorite : Icons.favorite_border,
                        size: 14, 
                        color: (comment['liked_by_me'] == true) ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${comment['likes_count'] ?? 0}', 
                        style: TextStyle(
                          color: (comment['liked_by_me'] == true) ? Colors.red : Colors.grey[700], 
                          fontSize: 11, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _replyingToCommentId = comment['idcomentario'];
                    _replyingToAuthorName = commentAuthorName;
                  });
                  FocusScope.of(context).requestFocus();
                },
                child: Row(
                  children: [
                    const Icon(Icons.reply, size: 14, color: Color(0xFF6B4EFF)),
                    const SizedBox(width: 4),
                    Text(
                      'Responder a ${commentAuthorName.split(' ')[0]}',
                      style: const TextStyle(color: Color(0xFF6B4EFF), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (children.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: depth == 0 ? 8.0 : 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var child in children)
                    _buildCommentNode(context, child, allComments, theme, depth + 1, commentAuthorName),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
