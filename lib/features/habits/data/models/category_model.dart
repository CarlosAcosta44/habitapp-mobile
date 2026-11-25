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

  static Color? _tryParseHexColor(String? rawHex) {
    if (rawHex == null || rawHex.isEmpty) return null;
    final hexString = rawHex.replaceAll('#', '');
    if (hexString.length == 6) {
      final val = int.tryParse('FF$hexString', radix: 16);
      return val != null ? Color(val) : null;
    }
    if (hexString.length == 8) {
      final val = int.tryParse(hexString, radix: 16);
      return val != null ? Color(val) : null;
    }
    return null;
  }

  static const List<MapEntry<List<String>, Color>> _categoryColorRules = [
    MapEntry(['ejercicio', 'deporte', 'correr'], Color(0xFFFF9800)),
    MapEntry(['hidratación', 'agua'], Color(0xFF2196F3)),
    MapEntry(['nutrición'], Color(0xFF4CAF50)),
    MapEntry(['productividad', 'lectura', 'estudio'], Color(0xFF9C27B0)),
    MapEntry(['salud mental', 'mente', 'mindfulness'], Color(0xFF009688)),
    MapEntry(['sueño'], Color(0xFF3F51B5)),
  ];

  /// Retorna un objeto Color derivado de colorHex o de acuerdo a la categoría
  Color get parsedColor {
    final fromHex = _tryParseHexColor(colorHex);
    if (fromHex != null) return fromHex;

    final nameLower = nombre.toLowerCase();
    for (final rule in _categoryColorRules) {
      if (rule.key.any(nameLower.contains)) return rule.value;
    }
    return const Color(0xFF3F51B5);
  }

  /// Retorna un objeto IconData derivado del nombre de la categoría
  IconData get parsedIcon {
    final nameLower = nombre.toLowerCase();
    if (nameLower.contains('ejercicio') || nameLower.contains('deporte') || nameLower.contains('correr')) return Icons.fitness_center;
    if (nameLower.contains('hidratación') || nameLower.contains('agua')) return Icons.water_drop;
    if (nameLower.contains('nutrición')) return Icons.restaurant;
    if (nameLower.contains('productividad') || nameLower.contains('lectura') || nameLower.contains('estudio')) return Icons.checklist;
    if (nameLower.contains('salud mental') || nameLower.contains('mente') || nameLower.contains('mindfulness')) return Icons.self_improvement;
    if (nameLower.contains('sueño')) return Icons.bedtime;
    return Icons.star_border_rounded;
  }
}
