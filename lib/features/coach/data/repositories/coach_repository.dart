import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../models/client_summary_model.dart';
import '../models/routine_summary_model.dart';

part 'coach_repository.g.dart';

class CoachRepository {
  final Dio _dio;

  CoachRepository(this._dio);

  Future<List<ClientSummary>> getClients() async {
    try {
      final response = await _dio.get('/coach/clients');
      return (response.data as List)
          .map((e) => ClientSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Mock temporal / Fallback
      await Future.delayed(const Duration(seconds: 1));
      return [
        ClientSummary(id: 'c1', fullName: 'Juan Pérez', email: 'juan@test.com'),
        ClientSummary(id: 'c2', fullName: 'María Gómez', email: 'maria@test.com'),
        ClientSummary(id: 'c3', fullName: 'Carlos López', email: 'carlos@test.com'),
      ];
    }
  }

  Future<List<RoutineSummary>> getRoutines() async {
    try {
      final response = await _dio.get('/coach/routines');
      return (response.data as List)
          .map((e) => RoutineSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Mock temporal / Fallback
      await Future.delayed(const Duration(seconds: 1));
      return [
        RoutineSummary(id: 'r1', title: 'Pérdida de Peso 30D', description: 'Rutina intensiva', totalExercises: 12),
        RoutineSummary(id: 'r2', title: 'Hipertrofia Básica', description: 'Ganancia muscular', totalExercises: 8),
      ];
    }
  }

  Future<void> assignRoutine({required String clientId, required String routineId}) async {
    try {
      await _dio.post('/coach/assign', data: {
        'clientId': clientId,
        'routineId': routineId,
      });
    } catch (e) {
      // Mock temporal / Fallback
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Mock: Assigned routine $routineId to client $clientId');
    }
  }
}

@riverpod
CoachRepository coachRepository(Ref ref) {
  return CoachRepository(ref.watch(dioClientProvider));
}
