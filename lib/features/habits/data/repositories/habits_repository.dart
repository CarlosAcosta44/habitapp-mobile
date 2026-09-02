import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/create_habit_dto.dart';
import '../models/habit_model.dart';

part 'habits_repository.g.dart';

@Riverpod(keepAlive: true)
HabitsRepository habitsRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return HabitsRepository(dio);
}

class HabitsRepository {
  final Dio _dio;

  HabitsRepository(this._dio);

  /// Obtiene los hábitos del usuario para el dashboard con progreso de hoy
  Future<List<HabitModel>> getDashboardHabits() async {
    try {
      final response = await _dio.get('/habits/dashboard');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => HabitModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al obtener los hábitos del dashboard',
      );
    }
  }

  /// Obtiene todas las categorías de hábitos registradas en el backend
  Future<List<CategoryModel>> getCategorias() async {
    try {
      final response = await _dio.get('/habits/categorias');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al obtener las categorías',
      );
    }
  }

  /// Crea un nuevo hábito enviando el CreateHabitDto al backend
  Future<HabitModel> createHabit(CreateHabitDto dto) async {
    try {
      final response = await _dio.post(
        '/habits',
        data: dto.toJson(),
      );
      return HabitModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al crear el hábito',
      );
    }
  }

  /// Marca un hábito como completado
  Future<void> marcarCompletado(String habitoId) async {
    try {
      await _dio.post(
        '/records/completar',
        data: {'idHabito': habitoId},
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al marcar hábito como completado',
      );
    }
  }

  /// Desmarca o remueve el cumplimiento de hoy
  Future<void> desmarcarCompletado(String habitoId) async {
    try {
      await _dio.delete('/records/desmarcar/$habitoId');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al desmarcar hábito',
      );
    }
  }

  /// Avanza el progreso numérico de un hábito hoy
  Future<void> avanzarProgreso(String habitoId, double cantidad) async {
    try {
      await _dio.patch(
        '/records/progreso',
        data: {
          'idHabito': habitoId,
          'cantidadASumar': cantidad,
        },
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al avanzar progreso del hábito',
      );
    }
  }
}
