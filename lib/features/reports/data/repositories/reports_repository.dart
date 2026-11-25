import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../models/habit_stats.dart';

part 'reports_repository.g.dart';

class ReportsRepository {
  final Dio _dio;

  ReportsRepository(this._dio);

  List<ChartDataPoint> _parseWeeklyProgress(List<dynamic> volumenSemanal) {
    const diasSemana = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final weeklyProgress = <ChartDataPoint>[];
    for (int i = 0; i < volumenSemanal.length && i < diasSemana.length; i++) {
      weeklyProgress.add(ChartDataPoint(
        label: diasSemana[i],
        value: (volumenSemanal[i] as num).toDouble(),
      ));
    }
    return weeklyProgress;
  }

  List<ChartDataPoint> _parseMonthlyProgress(List<dynamic> consistenciaMes) {
    return consistenciaMes
        .map((item) => ChartDataPoint(
              label: item['fecha'],
              value: (item['activos'] as num).toDouble(),
            ))
        .toList();
  }

  InsightData? _parseInsight(dynamic raw, {bool includeStreak = false}) {
    if (raw == null) return null;
    return InsightData(
      name: raw['nombre'],
      streak: includeStreak ? (raw['racha'] ?? 0) : null,
      rate: (raw['rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  HabitStats _mapToHabitStats(Map<String, dynamic> data) {
    final globalCompliance = (data['cumplimiento_global'] as num?)?.toDouble() ?? 0.0;
    return HabitStats(
      weeklyCompliancePercentage: globalCompliance,
      monthlyCompliancePercentage: globalCompliance,
      completedDays: data['total_cumplido'] ?? 0,
      totalExpectedDays: data['total_esperado'] ?? 0,
      currentStreak: data['racha_actual'] ?? 0,
      maxStreak: data['racha_maxima'] ?? 0,
      accumulatedPoints: data['puntos_totales'] ?? 0,
      smartInsight: data['insight'] ?? 'Continúa así para mantener tu consistencia.',
      weeklyProgress: _parseWeeklyProgress(data['volumen_semanal'] ?? []),
      monthlyProgress: _parseMonthlyProgress(data['consistencia_mes'] as List<dynamic>? ?? []),
      mostConsistentHabit: _parseInsight(data['mas_constante'], includeStreak: true),
      improvementOpportunity: _parseInsight(data['oportunidad_mejora']),
    );
  }

  Future<HabitStats> getHabitStats(String currentUserId, {String? targetUserId}) async {
    final idToFetch = targetUserId ?? currentUserId;
    try {
      final response = await _dio.get('/reports/user/$idToFetch');

      if (response.statusCode == 200) {
        return _mapToHabitStats(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load habit stats');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 404) {
        // Devuelve datos por defecto si el endpoint aún no está completamente implementado
        return const HabitStats(
          weeklyCompliancePercentage: 0.0,
          monthlyCompliancePercentage: 0.0,
          completedDays: 0,
          currentStreak: 0,
          accumulatedPoints: 0,
          weeklyProgress: [],
          monthlyProgress: [],
        );
      }
      throw Exception('Network error fetching habit stats: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching habit stats: $e');
    }
  }
}

@riverpod
ReportsRepository reportsRepository(Ref ref) {
  return ReportsRepository(ref.watch(dioClientProvider));
}
