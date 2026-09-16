import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../models/reto_model.dart';

part 'community_repository.g.dart';

@Riverpod(keepAlive: true)
CommunityRepository communityRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return CommunityRepository(dio);
}

class CommunityRepository {
  final Dio _dio;

  CommunityRepository(this._dio);

  static final List<RetoModel> _defaultRetos = [
    const RetoModel(
      id: 'reto-1',
      titulo: 'Reto 7 Días de Hidratación 💧',
      descripcion: 'Bebe al menos 2 litros de agua diariamente durante 7 días consecutivos. ¡Mantén tu cuerpo activo e hidratado!',
      puntosRecompensa: 150,
      categoria: 'Salud y Nutrición',
      isJoined: false,
      participantCount: 42,
      currentProgress: 0,
      targetCount: 7,
      icono: 'water_drop',
    ),
    const RetoModel(
      id: 'reto-2',
      titulo: 'Maratón de Lectura 📚',
      descripcion: 'Lee al menos 15 minutos al día durante 14 días. Desarrolla la disciplina del aprendizaje constante.',
      puntosRecompensa: 300,
      categoria: 'Crecimiento Personal',
      isJoined: false,
      participantCount: 89,
      currentProgress: 0,
      targetCount: 14,
      icono: 'menu_book',
    ),
    const RetoModel(
      id: 'reto-3',
      titulo: 'Desafío 30 Minutos de Deporte 🏃‍♂️',
      descripcion: 'Realiza al menos 30 minutos de actividad física diaria por 5 días esta semana. ¡Activa tu energía!',
      puntosRecompensa: 250,
      categoria: 'Deporte y Fitness',
      isJoined: false,
      participantCount: 128,
      currentProgress: 0,
      targetCount: 5,
      icono: 'fitness_center',
    ),
    const RetoModel(
      id: 'reto-4',
      titulo: 'Semana de Meditación y Mente Clara 🧘‍♀️',
      descripcion: 'Dedica 10 minutos cada mañana a respiración guiada o meditación para reducir el estrés.',
      puntosRecompensa: 200,
      categoria: 'Bienestar Mental',
      isJoined: false,
      participantCount: 64,
      currentProgress: 0,
      targetCount: 7,
      icono: 'self_improvement',
    ),
  ];

  /// Obtiene los retos activos de la comunidad
  Future<List<RetoModel>> getRetos() async {
    try {
      final response = await _dio.get('/community/retos');
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        return data.map((e) => RetoModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return _defaultRetos;
    } on DioException catch (e) {
      debugPrint('Error en GET /community/retos: ${e.message}. Usando lista por defecto.');
      return _defaultRetos;
    } catch (e) {
      debugPrint('Excepción al cargar retos: $e. Usando lista por defecto.');
      return _defaultRetos;
    }
  }

  /// Permite al usuario unirse a un reto determinado
  Future<bool> joinChallenge(String retoId) async {
    try {
      final response = await _dio.post(
        '/community/retos/$retoId/join',
        data: {'retoId': retoId},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint('Warn/Error al unirse al reto via API: ${e.message}. Manejando éxito local.');
      return true;
    } catch (e) {
      debugPrint('Excepción al unirse al reto: $e');
      return true;
    }
  }
}
