// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      id: _readId(json, 'id') as String,
      nombre: _readNombre(json, 'nombre') as String,
      descripcion: json['descripcion'] as String?,
      icono: json['icono'] as String?,
      colorHex: json['colorHex'] as String?,
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'icono': instance.icono,
      'colorHex': instance.colorHex,
    };
