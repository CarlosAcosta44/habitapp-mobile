import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../domain/habit_stats.dart';

part 'reports_repository.g.dart';

class ReportsRepository {
  final Dio _dio;

  ReportsRepository(this._dio);

  Future<HabitStats> getHabitStats(String userId) async {
    try {
      final response = await _dio.get('/reports/user/$userId');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        final List<dynamic> volumenSemanal = data['volumen_semanal'] ?? [];
        final diasSemana = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
        final weeklyProgress = <ChartDataPoint>[];
        for (int i = 0; i < volumenSemanal.length && i < diasSemana.length; i++) {
          weeklyProgress.add(ChartDataPoint(
            label: diasSemana[i],
            value: (volumenSemanal[i] as num).toDouble(),
          ));
        }

        InsightData? masConstante;
        if (data['mas_constante'] != null) {
          masConstante = InsightData(
            name: data['mas_constante']['nombre'],
            streak: data['mas_constante']['racha'] ?? 0,
            rate: (data['mas_constante']['rate'] as num?)?.toDouble() ?? 0.0,
          );
        }

        InsightData? oportunidad;
        if (data['oportunidad_mejora'] != null) {
          oportunidad = InsightData(
            name: data['oportunidad_mejora']['nombre'],
            rate: (data['oportunidad_mejora']['rate'] as num?)?.toDouble() ?? 0.0,
          );
        }

        return HabitStats(
          weeklyCompliancePercentage: (data['cumplimiento_global'] as num?)?.toDouble() ?? 0.0,
          monthlyCompliancePercentage: (data['cumplimiento_global'] as num?)?.toDouble() ?? 0.0,
          completedDays: data['total_cumplido'] ?? 0,
          totalExpectedDays: data['total_esperado'] ?? 0,
          currentStreak: data['racha_actual'] ?? 0,
          maxStreak: data['racha_maxima'] ?? 0,
          accumulatedPoints: data['puntos_totales'] ?? 0,
          smartInsight: data['insight'] ?? 'Continúa así para mantener tu consistencia.',
          weeklyProgress: weeklyProgress,
          mostConsistentHabit: masConstante,
          improvementOpportunity: oportunidad,
        );
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
