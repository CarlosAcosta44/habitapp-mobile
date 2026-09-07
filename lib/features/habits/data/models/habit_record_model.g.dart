// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitRecordModel _$HabitRecordModelFromJson(Map<String, dynamic> json) =>
    _HabitRecordModel(
      fecha: json['fecha'] as String,
      completado: json['completado'] as bool,
      progresoActual: (json['progresoActual'] as num).toDouble(),
      puntosGanados: (json['puntosGanados'] as num).toInt(),
    );

Map<String, dynamic> _$HabitRecordModelToJson(_HabitRecordModel instance) =>
    <String, dynamic>{
      'fecha': instance.fecha,
      'completado': instance.completado,
      'progresoActual': instance.progresoActual,
      'puntosGanados': instance.puntosGanados,
    };
