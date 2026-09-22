import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../profile/providers/profile_provider.dart';
import '../data/repositories/reports_repository.dart';
import '../data/models/habit_stats.dart';

part 'reports_provider.g.dart';

@riverpod
Future<HabitStats> habitStats(Ref ref, {String? targetUserId}) async {
  final userProfile = await ref.watch(profileProvider.future);
  if (userProfile == null) throw Exception('No user profile found');

  return ref
      .watch(reportsRepositoryProvider)
      .getHabitStats(userProfile.idusuario, targetUserId: targetUserId);
}

@riverpod
Future<List<FlSpot>> weeklyProgressChartData(Ref ref, {String? targetUserId}) async {
  final stats = await ref.watch(habitStatsProvider(targetUserId: targetUserId).future);

  if (stats.weeklyProgress.isEmpty) {
    // Si no hay datos, proveemos un mock para visualización inicial
    return const [
      FlSpot(0, 0),
      FlSpot(1, 20),
      FlSpot(2, 50),
      FlSpot(3, 40),
      FlSpot(4, 80),
      FlSpot(5, 60),
      FlSpot(6, 90),
    ];
  }

  return stats.weeklyProgress.asMap().entries.map((entry) {
    return FlSpot(entry.key.toDouble(), entry.value.value);
  }).toList();
}

@riverpod
Future<List<BarChartGroupData>> monthlyProgressBarData(Ref ref, {String? targetUserId}) async {
  final stats = await ref.watch(habitStatsProvider(targetUserId: targetUserId).future);

  if (stats.monthlyProgress.isEmpty) {
    // Mock para visualización inicial
    return List.generate(4, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 20.0,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  return stats.monthlyProgress.asMap().entries.map((entry) {
    return BarChartGroupData(
      x: entry.key,
      barRods: [
        BarChartRodData(
          toY: entry.value.value,
          width: 15,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }).toList();
}
