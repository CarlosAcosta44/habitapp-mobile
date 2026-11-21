import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';

part 'community_repository.g.dart';

@Riverpod(keepAlive: true)
CommunityRepository communityRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return CommunityRepository(dio);
}

class CommunityRepository {
  final Dio _dio;

  CommunityRepository(this._dio);

  // ================= Foros =================
  Future<List<dynamic>> getForums() async {
    try {
      final response = await _dio.get('/users/community/foros');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Error al cargar los foros');
    }
  }

  Future<dynamic> createForum(String titulo, String descripcion, String categoria, {String? imagenUrl}) async {
    try {
      final response = await _dio.post('/users/community/foros', data: {
        'titulo': titulo,
        'descripcion': descripcion,
        'categoria': categoria,
        'imagenUrl': ?imagenUrl,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al crear foro');
    }
  }

  Future<dynamic> updateForum(String id, {String? titulo, String? descripcion, String? categoria, String? imagenUrl}) async {
    try {
      final response = await _dio.put('/users/community/foros/$id', data: {
        'titulo': ?titulo,
        'descripcion': ?descripcion,
        'categoria': ?categoria,
        'imagenUrl': ?imagenUrl,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al actualizar foro');
    }
  }

  Future<void> deleteForum(String id) async {
    try {
      await _dio.delete('/users/community/foros/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al eliminar foro');
    }
  }

  Future<List<dynamic>> getComments(String forumId) async {
    try {
      final response = await _dio.get('/users/community/foros/$forumId/comentarios');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener comentarios');
    }
  }

  Future<dynamic> addComment(String forumId, String contenido, {String? parentId, String? imagenUrl}) async {
    try {
      final response = await _dio.post('/users/community/foros/$forumId/comentarios', data: {
        'contenido': contenido,
        'parentId': ?parentId,
        'imagenUrl': ?imagenUrl,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al añadir comentario');
    }
  }

  Future<void> deleteComment(String id) async {
    try {
      await _dio.delete('/users/community/comentarios/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al eliminar comentario');
    }
  }

  Future<String> uploadImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post('/users/community/upload-image', data: formData);
      return response.data['url'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al subir la imagen');
    }
  }

  Future<dynamic> updateComment(String id, String contenido, {String? imagenUrl}) async {
    try {
      final response = await _dio.put('/users/community/comentarios/$id', data: {
        'contenido': contenido,
        'imagenUrl': ?imagenUrl,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al actualizar comentario');
    }
  }


  Future<dynamic> addReaction(String targetType, String targetId, String tipo) async {
    try {
      final response = await _dio.post('/users/community/$targetType/$targetId/reacciones', data: {
        'tipo': tipo,
      });
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al añadir reacción');
    }
  }

  // ================= Retos =================
  Future<List<dynamic>> getRetos() async {
    try {
      final response = await _dio.get('/users/community/retos');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Error al obtener reto');
    }
  }

  Future<dynamic> joinReto(String retoId) async {
    try {
      final response = await _dio.post('/users/community/retos/$retoId/unirse');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al unirse al reto');
    }
  }

  Future<dynamic> leaveReto(String retoId) async {
    try {
      final response = await _dio.post('/users/community/retos/$retoId/salir');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al abandonar el reto');
    }
  }

  Future<dynamic> checkinReto(String retoId) async {
    try {
      final response = await _dio.post('/users/community/retos/$retoId/checkin');
      return response.data;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Error al registrar avance en el reto');
    }
  }

  // ================= Especialistas =================
  Future<List<dynamic>> getEspecialistas() async {
    try {
      final response = await _dio.get('/users/community/especialistas');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener especialistas');
    }
  }

  // ================= Artículos =================
  Future<List<dynamic>> getArticulos() async {
    try {
      final response = await _dio.get('/users/community/articulos');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener artículos');
    }
  }

  // ================= Hábitos Comunitarios =================
  Future<List<dynamic>> getCommunityHabits() async {
    try {
      final response = await _dio.get('/users/community/habitos');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al obtener hábitos comunitarios');
    }
  }

  Future<dynamic> cloneHabit(String idhabito) async {
    try {
      final response = await _dio.post('/users/community/habitos/$idhabito/clonar');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al clonar hábito');
    }
  }

  Future<dynamic> shareHabit(String idhabito) async {
    try {
      final response = await _dio.post('/users/community/habitos/$idhabito/compartir');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al compartir hábito');
    }
  }

  Future<dynamic> deleteSharedHabit(String idhabito) async {
    try {
      final response = await _dio.delete('/users/community/habitos/$idhabito');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al eliminar hábito compartido');
    }
  }
}
