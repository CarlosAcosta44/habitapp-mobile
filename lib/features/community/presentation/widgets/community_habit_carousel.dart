import 'package:flutter/material.dart';
import '../../data/models/community_feed_models.dart';

const _kBlue = Color(0xFF2D82FA);
const _kGreen = Color(0xFF0F8A5D);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);

class CommunityHabitCarousel extends StatelessWidget {
  final List<CommunityHabitItem> habits;
  final ValueChanged<String> onAddHabit;
  final VoidCallback onSeeAll;

  const CommunityHabitCarousel({
    super.key,
    required this.habits,
    required this.onAddHabit,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4EE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bubble_chart_rounded,
                    color: _kGreen,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Hábitos de la comunidad',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _kTextDark,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'Ver todos',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _kGreen,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        const Text(
          'Inspirados por otros miembros para cuidar la salud emocional día a día.',
          style: TextStyle(
            fontSize: 11.5,
            color: _kTextGrey,
            height: 1.3,
          ),
        ),

        const SizedBox(height: 14),

        // Horizontal Carousel
        SizedBox(
          height: 175,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: habits.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final habit = habits[index];
              return _CommunityHabitCard(
                habit: habit,
                onAdd: () => onAddHabit(habit.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CommunityHabitCard extends StatelessWidget {
  final CommunityHabitItem habit;
  final VoidCallback onAdd;

  const _CommunityHabitCard({
    required this.habit,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and Popular Badge row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: habit.iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  habit.icon,
                  color: habit.iconColor,
                  size: 20,
                ),
              ),
              if (habit.badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBF2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    habit.badgeText!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE22D6F),
                    ),
                  ),
                ),
            ],
          ),

          // Title & Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: _kTextDark,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                habit.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: _kTextGrey,
                  height: 1.25,
                ),
              ),
            ],
          ),

          // Footer: Participants count and Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.group_outlined,
                    size: 14,
                    color: _kGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    habit.participantsCount,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: _kGreen,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onAdd,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: habit.isAdded ? const Color(0xFFE6F4EE) : _kBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        habit.isAdded ? Icons.check : Icons.add,
                        size: 13,
                        color: habit.isAdded ? _kGreen : Colors.white,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        habit.isAdded ? 'Agregado' : 'Añadir',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: habit.isAdded ? _kGreen : Colors.white,
                        ),
                      ),
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

