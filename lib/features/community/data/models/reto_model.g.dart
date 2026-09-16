// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RetoModel _$RetoModelFromJson(Map<String, dynamic> json) => _RetoModel(
  id: _readId(json, 'id') as String,
  titulo: _readTitulo(json, 'titulo') as String,
  descripcion: _readDescripcion(json, 'descripcion') as String? ?? '',
  puntosRecompensa:
      (_readPuntos(json, 'puntosRecompensa') as num?)?.toInt() ?? 100,
  fechaInicio: json['fechaInicio'] as String?,
  fechaFin: json['fechaFin'] as String?,
  categoria: json['categoria'] as String?,
  isJoined: _readIsJoined(json, 'isJoined') as bool? ?? false,
  participantCount:
      (_readParticipantCount(json, 'participantCount') as num?)?.toInt() ?? 1,
  currentProgress:
      (_readCurrentProgress(json, 'currentProgress') as num?)?.toInt() ?? 0,
  targetCount: (_readTargetCount(json, 'targetCount') as num?)?.toInt() ?? 7,
  icono: json['icono'] as String?,
);

Map<String, dynamic> _$RetoModelToJson(_RetoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descripcion': instance.descripcion,
      'puntosRecompensa': instance.puntosRecompensa,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'categoria': instance.categoria,
      'isJoined': instance.isJoined,
      'participantCount': instance.participantCount,
      'currentProgress': instance.currentProgress,
      'targetCount': instance.targetCount,
      'icono': instance.icono,
    };
