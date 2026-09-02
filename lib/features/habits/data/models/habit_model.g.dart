// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitModel _$HabitModelFromJson(Map<String, dynamic> json) => _HabitModel(
  id: json['id'] as String,
  nombre: json['nombre'] as String,
  descripcion: json['descripcion'] as String?,
  puntos: (json['puntos'] as num?)?.toInt() ?? 10,
  metaDiaria: (json['metaDiaria'] as num?)?.toDouble() ?? 1.0,
  unidadMedida: json['unidadMedida'] as String? ?? 'veces',
  idCategoria: json['idCategoria'] as String?,
  categoria: json['categoria'] == null
      ? null
      : CategoryModel.fromJson(json['categoria'] as Map<String, dynamic>),
  completadoHoy: json['completadoHoy'] as bool? ?? false,
  progresoHoy: (json['progresoHoy'] as num?)?.toDouble() ?? 0.0,
  rachaActual: (json['rachaActual'] as num?)?.toInt() ?? 0,
  fechaInicio: json['fechaInicio'] as String?,
  fechaFin: json['fechaFin'] as String?,
);

Map<String, dynamic> _$HabitModelToJson(_HabitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'puntos': instance.puntos,
      'metaDiaria': instance.metaDiaria,
      'unidadMedida': instance.unidadMedida,
      'idCategoria': instance.idCategoria,
      'categoria': instance.categoria,
      'completadoHoy': instance.completadoHoy,
      'progresoHoy': instance.progresoHoy,
      'rachaActual': instance.rachaActual,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
    };
