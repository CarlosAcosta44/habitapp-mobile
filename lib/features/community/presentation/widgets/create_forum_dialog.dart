import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/community_feed_provider.dart';

class CreateForumDialog extends ConsumerStatefulWidget {
  const CreateForumDialog({super.key});

  @override
  ConsumerState<CreateForumDialog> createState() => _CreateForumDialogState();
}

class _CreateForumDialogState extends ConsumerState<CreateForumDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El título y la descripción son obligatorios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(communityFeedProvider.notifier).createForum(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _categoryController.text.trim().isEmpty ? 'Comunidad' : _categoryController.text.trim(),
      );
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foro creado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear foro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String hintText,
    required TextEditingController controller,
    int maxLines = 1,
    int? maxLength,
    Widget? trailingLabel,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : const Color(0xFFF3E8FF);
    final textColor = theme.colorScheme.onSurface;
    final hintColor = isDark ? Colors.grey[500] : Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
            ?trailingLabel,
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(color: textColor, fontSize: 13),
            onChanged: (val) {
              if (maxLength != null) setState(() {});
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: hintColor, fontSize: 13),
              border: InputBorder.none,
              counterText: '', 
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final primaryLightColor = isDark ? const Color(0xFF6B4EFF).withValues(alpha: 0.2) : const Color(0xFFF3E8FF);
    
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: bottomPadding + 24,
        top: 12,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Crear un Foro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurfaceColor)),
                    const SizedBox(height: 4),
                    Text(
                      'Comparte tus dudas, experiencias o reflexiones con la comunidad',
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: primaryLightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, size: 16, color: onSurfaceColor.withValues(alpha: 0.6)),
                ),
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: isDark ? Colors.grey[800] : const Color(0xFFF0F0F0)),
          ),
          
          _buildTextField(
            context: context,
            label: 'Categoría / Etiqueta temática',
            hintText: 'Ej: Ansiedad, Mindfulness o Hábitos',
            controller: _categoryController,
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            context: context,
            label: 'Título del foro',
            hintText: '¿Cómo gestionáis la ansiedad matutina?',
            controller: _titleController,
          ),
          
          const SizedBox(height: 16),
          
          _buildTextField(
            context: context,
            label: '¿Qué quieres compartir o preguntar?',
            hintText: 'Llevo varios días notando una sensación de aceleración nada más levantarme. ¿Qué rutinas o respiraciones os ayudan más en los primeros 15 minutos?',
            controller: _descriptionController,
            maxLines: 4,
            maxLength: 500,
            trailingLabel: Text(
              '${_descriptionController.text.length} / 500',
              style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[500] : Colors.grey),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Buttons
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryLightColor,
                    foregroundColor: onSurfaceColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading 
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Publicar Foro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
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
