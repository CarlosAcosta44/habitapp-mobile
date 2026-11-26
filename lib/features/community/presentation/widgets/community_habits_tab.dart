import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/community_feed_models.dart';
import '../../../habits/providers/habits_provider.dart';
import 'share_habit_bottom_sheet.dart';

const _kBlue = Color(0xFF2D82FA);
const _kGreen = Color(0xFF0F8A5D);

class CommunityHabitsTab extends ConsumerStatefulWidget {
  final List<CommunityHabitItem> habits;
  final ValueChanged<String> onAddHabit;
  final ValueChanged<String> onDeleteHabit;

  const CommunityHabitsTab({
    super.key,
    required this.habits,
    required this.onAddHabit,
    required this.onDeleteHabit,
  });

  @override
  ConsumerState<CommunityHabitsTab> createState() => _CommunityHabitsTabState();
}

class _CommunityHabitsTabState extends ConsumerState<CommunityHabitsTab> {
  String _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Filtrado
    final filteredHabits = _selectedCategory == 'Todos' 
        ? widget.habits 
        : widget.habits.where((h) => h.badgeText == _selectedCategory).toList();

    // Obtener las categorías reales
    final categoriesAsync = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner principal
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B4EFF), Color(0xFF4C30D4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B4EFF).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Comunidad en Movimiento',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Inspira a miles\ncompartiendo tu hábito',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tus pequeñas victorias diarias pueden encender el cambio que alguien más está buscando hoy.',
                style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 24,
                    child: Stack(
                      children: [
                        const Positioned(
                          left: 0,
                          child: CircleAvatar(radius: 12, backgroundColor: Colors.white, child: Padding(padding: EdgeInsets.all(1), child: CircleAvatar(radius: 11, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=1')))),
                        ),
                        const Positioned(
                          left: 16,
                          child: CircleAvatar(radius: 12, backgroundColor: Colors.white, child: Padding(padding: EdgeInsets.all(1), child: CircleAvatar(radius: 11, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=2')))),
                        ),
                        const Positioned(
                          left: 32,
                          child: CircleAvatar(radius: 12, backgroundColor: Colors.white, child: Padding(padding: EdgeInsets.all(1), child: CircleAvatar(radius: 11, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=3')))),
                        ),
                        Positioned(
                          left: 48,
                          child: CircleAvatar(radius: 12, backgroundColor: Colors.white, child: Padding(padding: const EdgeInsets.all(1), child: CircleAvatar(radius: 11, backgroundColor: Colors.grey[200], child: const Text('+9', style: TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold))))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('3.8k rutinas vivas', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const ShareHabitBottomSheet(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6B4EFF),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('+ Compartir hábito', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Explorar Temas Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Explorar temas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const Text(
              'Ver todos',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _kGreen,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Chips de Categorías
        SizedBox(
          height: 36,
          child: categoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const Text('Error al cargar categorías'),
            data: (cats) {
              final categoriesList = ['Todos', ...cats.map((c) => c.nombre)];
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categoriesList[index];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? _kBlue : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? _kBlue : colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // Lista de Hábitos
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredHabits.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final habit = filteredHabits[index];
            return CommunityHabitCard(
              habit: habit,
              onAdd: () => widget.onAddHabit(habit.id),
              onDelete: () => widget.onDeleteHabit(habit.id),
            );
          },
        ),
      ],
    );
  }
}

class CommunityHabitCard extends StatelessWidget {
  final CommunityHabitItem habit;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  const CommunityHabitCard({
    super.key,
    required this.habit,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.surfaceContainerHighest, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono a la izquierda
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: habit.iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              habit.icon,
              color: habit.iconColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          
          // Contenido principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    habit.badgeText ?? 'General',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        habit.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (habit.isMine)
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.more_vert, size: 20, color: colorScheme.onSurfaceVariant),
                        onSelected: (value) {
                          if (value == 'delete') {
                            onDelete();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text('Eliminar', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  habit.description.isNotEmpty ? habit.description : 'Un hábito para mejorar tu estilo de vida',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people_alt_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          habit.participantsCount,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (!habit.isMine)
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: habit.isAdded ? null : onAdd,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: habit.isAdded ? _kGreen.withValues(alpha: 0.1) : _kBlue.withValues(alpha: 0.1),
                            foregroundColor: habit.isAdded ? _kGreen : _kBlue,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            habit.isAdded ? 'Añadido' : '+ Añadir a mis hábitos',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
