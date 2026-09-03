import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

Object? _readId(Map json, String key) {
  return json['id'] ??
      json['idcategoria'] ??
      json['id_categoria'] ??
      json['idCategoria'] ??
      '';
}

Object? _readNombre(Map json, String key) {
  return json['nombre'] ??
      json['name'] ??
      json['nombrecategoria'] ??
      json['nombreCategoria'] ??
      'General';
}

@freezed
abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._(); // Permite agregar métodos/getters personalizados

  const factory CategoryModel({
    @JsonKey(name: 'id', readValue: _readId) required String id,
    @JsonKey(name: 'nombre', readValue: _readNombre) required String nombre,
    String? descripcion,
    String? icono,
    String? colorHex,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Retorna un objeto Color derivado de colorHex o de acuerdo a la categoría
  Color get parsedColor {
    if (colorHex != null && colorHex!.isNotEmpty) {
      final hexString = colorHex!.replaceAll('#', '');
      if (hexString.length == 6) {
        final val = int.tryParse('FF$hexString', radix: 16);
        if (val != null) return Color(val);
      } else if (hexString.length == 8) {
        final val = int.tryParse(hexString, radix: 16);
        if (val != null) return Color(val);
      }
    }
    final nameLower = nombre.toLowerCase();
    if (nameLower.contains('salud')) return const Color(0xFF4CAF50);
    if (nameLower.contains('deporte') || nameLower.contains('correr')) return const Color(0xFFFF9800);
    if (nameLower.contains('lectura') || nameLower.contains('estudio')) return const Color(0xFF9C27B0);
    if (nameLower.contains('mente') || nameLower.contains('mindfulness')) return const Color(0xFF009688);
    if (nameLower.contains('agua') || nameLower.contains('nutrición')) return const Color(0xFF2196F3);
    return const Color(0xFF3F51B5);
  }
}
