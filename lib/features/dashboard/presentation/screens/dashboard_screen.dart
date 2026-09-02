import 'package:flutter/material.dart';

import '../../../habits/presentation/widgets/daily_progress_bar.dart';
import '../../../habits/presentation/widgets/habit_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

            // Progress Bar
            const DailyProgressBar(),
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
            
            const HabitCard(
              title: 'Beber agua',
              subtitle: '500/2000 ML',
              icon: Icons.water_drop,
              progress: 0.25,
            ),
            const SizedBox(height: 12),
            const HabitCard(
              title: 'Caminar',
              subtitle: '0/10000 PASOS',
              icon: Icons.directions_walk,
              progress: 0.0,
            ),
            const SizedBox(height: 12),
            const HabitCard(
              title: 'Regar plantas',
              subtitle: '0/1',
              icon: Icons.local_florist,
              progress: 0.0,
            ),
            const SizedBox(height: 100), // padding for bottom nav bar
          ],
        ),
      ),
    );
  }
}
