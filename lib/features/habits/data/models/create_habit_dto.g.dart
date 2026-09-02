// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_habit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateHabitDto _$CreateHabitDtoFromJson(Map<String, dynamic> json) =>
    _CreateHabitDto(
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      fechaInicio: json['fechaInicio'] as String,
      fechaFin: json['fechaFin'] as String?,
      puntos: (json['puntos'] as num).toInt(),
      metaDiaria: (json['metaDiaria'] as num?)?.toDouble(),
      unidadMedida: json['unidadMedida'] as String?,
      idCategoria: json['idCategoria'] as String,
      diasSemana:
          (json['diasSemana'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [1, 2, 3, 4, 5, 6, 7],
    );

Map<String, dynamic> _$CreateHabitDtoToJson(_CreateHabitDto instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'puntos': instance.puntos,
      'metaDiaria': instance.metaDiaria,
      'unidadMedida': instance.unidadMedida,
      'idCategoria': instance.idCategoria,
    };
