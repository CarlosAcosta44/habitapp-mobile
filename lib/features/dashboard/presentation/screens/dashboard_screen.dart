import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../habits/presentation/widgets/daily_progress_bar.dart';
import '../../../habits/presentation/widgets/habit_card.dart';
import '../../../habits/providers/mock_habits_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(mockHabitsProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Hola, Carlos 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              '¡Construyamos hábitos juntos!',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Toggle Hoy / Foros
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text('Hoy', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('Foros', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Horizontal Calendar (Static for now)
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final isSelected = index == 1; // 3 SA
                  return Container(
                    width: 50,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(16),
                      color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${index + 2}', style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.blue : Colors.black)),
                        Text(['VI', 'SA', 'DO', 'LU', 'MA', 'MI', 'JU'][index], style: TextStyle(fontSize: 10, color: isSelected ? Colors.blue : Colors.grey)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Progress Bar (Dynamic)
            DailyProgressBar(
              completed: habits.where((h) => h.isCompleted).length,
              total: habits.length,
            ),
            const SizedBox(height: 24),

            // Retos Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Retos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: const Text('VER MÁS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.directions_run, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('¡Mejores corredores!', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Quedan 5 días 13 horas', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hábitos Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hábitos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: const Text('VER MÁS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: habits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final habit = habits[index];
                return HabitCard(
                  title: habit.title,
                  subtitle: habit.subtitle,
                  icon: habit.icon,
                  progress: habit.initialProgress,
                  isCompleted: habit.isCompleted,
                  onToggle: () {
                    ref.read(mockHabitsProvider.notifier).toggleHabit(habit.id);
                  },
                );
              },
            ),
            const SizedBox(height: 100), // padding for bottom nav bar
          ],
        ),
      ),
    );
  }
}
