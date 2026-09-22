import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
        return data.map((e) {
          final map = e as Map<String, dynamic>;
          if (map['registroHoy'] != null) {
            map['completadoHoy'] = map['registroHoy']['completado'] ?? false;
            map['progresoHoy'] = (map['registroHoy']['progresoActual'] ?? 0).toDouble();
          }
          return HabitModel.fromJson(map);
        }).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al obtener los hábitos del dashboard',
      );
    }
  }

  /// Obtiene los hábitos archivados del usuario
  Future<List<HabitModel>> getArchivedHabits() async {
    try {
      final response = await _dio.get('/habits?estado=Inactivo');
      final data = response.data;
      if (data is List) {
        return data.map((e) => HabitModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al obtener los hábitos archivados',
      );
    }
  }

  /// Obtiene todas las categorías de hábitos registradas en el backend
  Future<List<CategoryModel>> getCategorias() async {
    final defaultCategories = [
      CategoryModel(id: 'cat-salud', nombre: 'Salud', icono: 'salud'),
      CategoryModel(id: 'cat-deporte', nombre: 'Deporte', icono: 'deporte'),
      CategoryModel(id: 'cat-lectura', nombre: 'Lectura', icono: 'lectura'),
      CategoryModel(id: 'cat-mente', nombre: 'Mindfulness', icono: 'mindfulness'),
      CategoryModel(id: 'cat-agua', nombre: 'Agua & Nutrición', icono: 'agua'),
    ];

    try {
      final response = await _dio.get('/habits/categorias');
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        final parsed = data
            .map((e) {
              if (e is Map<String, dynamic>) {
                return CategoryModel.fromJson(e);
              }
              return null;
            })
            .whereType<CategoryModel>()
            .toList();

        if (parsed.isNotEmpty) return parsed;
      }
      return defaultCategories;
    } catch (e, stack) {
      debugPrint('ERROR fetching categories: $e\n$stack');
      return defaultCategories;
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
        '/users/records/completar',
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
      await _dio.delete('/users/records/desmarcar/$habitoId');
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
        '/users/records/progreso',
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

  /// Obtiene el detalle completo de un hábito con sus estadísticas
  Future<HabitModel> getHabitStats(String habitoId) async {
    try {
      final response = await _dio.get('/habits/$habitoId/stats');
      final map = response.data as Map<String, dynamic>;
      if (map['registroHoy'] != null) {
        map['completadoHoy'] = map['registroHoy']['completado'] ?? false;
        map['progresoHoy'] =
            (map['registroHoy']['progresoActual'] ?? 0).toDouble();
      }
      return HabitModel.fromJson(map);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al obtener detalle del hábito',
      );
    }
  }

  /// Actualiza los campos de un hábito existente
  Future<HabitModel> updateHabit(
      String habitoId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/habits/$habitoId', data: data);
      final map = response.data as Map<String, dynamic>;
      if (map['registroHoy'] != null) {
        map['completadoHoy'] = map['registroHoy']['completado'] ?? false;
        map['progresoHoy'] =
            (map['registroHoy']['progresoActual'] ?? 0).toDouble();
      }
      return HabitModel.fromJson(map);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al actualizar el hábito',
      );
    }
  }

  /// Elimina un hábito permanentemente
  Future<void> deleteHabit(String habitoId) async {
    try {
      await _dio.delete('/habits/$habitoId');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al eliminar el hábito',
      );
    }
  }
}
