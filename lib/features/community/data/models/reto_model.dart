import 'package:freezed_annotation/freezed_annotation.dart';

part 'reto_model.freezed.dart';
part 'reto_model.g.dart';

Object? _readId(Map json, String key) {
  return json['id'] ?? json['id_reto'] ?? json['idReto'] ?? '';
}

Object? _readTitulo(Map json, String key) {
  return json['titulo'] ?? json['title'] ?? json['nombre'] ?? 'Reto Sin Título';
}

Object? _readDescripcion(Map json, String key) {
  return json['descripcion'] ?? json['description'] ?? '';
}

Object? _readPuntos(Map json, String key) {
  return json['puntosRecompensa'] ?? json['puntos_recompensa'] ?? json['puntos'] ?? json['points'] ?? 100;
}

Object? _readIsJoined(Map json, String key) {
  return json['isJoined'] ?? json['is_joined'] ?? json['joined'] ?? false;
}

Object? _readParticipantCount(Map json, String key) {
  return json['participantCount'] ?? json['participant_count'] ?? json['participantes'] ?? 1;
}

Object? _readCurrentProgress(Map json, String key) {
  return json['currentProgress'] ?? json['current_progress'] ?? json['progreso'] ?? 0;
}

Object? _readTargetCount(Map json, String key) {
  return json['targetCount'] ?? json['target_count'] ?? json['meta'] ?? 7;
}

@freezed
abstract class RetoModel with _$RetoModel {
  const RetoModel._();

  const factory RetoModel({
    @JsonKey(name: 'id', readValue: _readId) required String id,
    @JsonKey(name: 'titulo', readValue: _readTitulo) required String titulo,
    @JsonKey(name: 'descripcion', readValue: _readDescripcion) @Default('') String descripcion,
    @JsonKey(name: 'puntosRecompensa', readValue: _readPuntos) @Default(100) int puntosRecompensa,
    String? fechaInicio,
    String? fechaFin,
    String? categoria,
    @JsonKey(name: 'isJoined', readValue: _readIsJoined) @Default(false) bool isJoined,
    @JsonKey(name: 'participantCount', readValue: _readParticipantCount) @Default(1) int participantCount,
    @JsonKey(name: 'currentProgress', readValue: _readCurrentProgress) @Default(0) int currentProgress,
    @JsonKey(name: 'targetCount', readValue: _readTargetCount) @Default(7) int targetCount,
    String? icono,
  }) = _RetoModel;

  factory RetoModel.fromJson(Map<String, dynamic> json) =>
      _$RetoModelFromJson(json);

  double get progressPercentage {
    if (targetCount <= 0) return 0.0;
    final pct = currentProgress / targetCount;
    return pct > 1.0 ? 1.0 : pct;
  }
}
