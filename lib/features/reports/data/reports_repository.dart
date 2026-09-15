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
      final response = await _dio.get('/reports/user/$userId/stats');

      if (response.statusCode == 200) {
        return HabitStats.fromJson(response.data as Map<String, dynamic>);
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
