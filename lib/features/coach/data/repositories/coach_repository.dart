import 'package:dio/dio.dart';
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
      final list = response.data as List<dynamic>;
      return list
          .where((e) => e is Map<String, dynamic> && (e['client'] != null || e['id'] != null || e['idusuario'] != null))
          .map((e) => ClientSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Error al obtener clientes asignados',
      );
    }
  }

  Future<List<RoutineSummary>> getRoutines() async {
    try {
      final response = await _dio.get('/coach/routines');
      return (response.data as List<dynamic>)
          .map((e) => RoutineSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Error al obtener rutinas del entrenador',
      );
    }
  }

  Future<void> assignRoutine({required String clientId, required String routineId}) async {
    try {
      await _dio.post('/coach/clients/$clientId/routines/$routineId/assign');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Error al asignar rutina al cliente',
      );
    }
  }

  Future<Map<String, dynamic>> getClientProgress(String clientId) async {
    try {
      final response = await _dio.get('/coach/clients/$clientId/progress');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Error al obtener progreso del cliente',
      );
    }
  }

  Future<void> sendRecommendation({
    required String clientId,
    required String message,
    String type = 'Recomendación',
  }) async {
    try {
      await _dio.post(
        '/coach/clients/$clientId/recommendation',
        data: {'message': message, 'type': type},
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Error al enviar recomendación',
      );
    }
  }

  Future<List<ClientSummary>> getAvailableClients() async {
    try {
      final response = await _dio.get('/coach/available-clients');
      return (response.data as List<dynamic>)
          .map((e) => ClientSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Error al obtener alumnos disponibles',
      );
    }
  }

  Future<void> linkClient(String clientId) async {
    try {
      await _dio.post('/coach/clients/$clientId/link');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Error al vincular cliente',
      );
    }
  }

  Future<void> unlinkClient(String clientId) async {
    try {
      await _dio.delete('/coach/clients/$clientId/link');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Error al desvincular cliente',
      );
    }
  }
}

@riverpod
CoachRepository coachRepository(Ref ref) {
  return CoachRepository(ref.watch(dioClientProvider));
}
