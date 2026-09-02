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
  const factory CategoryModel({
    @JsonKey(name: 'id', readValue: _readId) required String id,
    @JsonKey(name: 'nombre', readValue: _readNombre) required String nombre,
    String? descripcion,
    String? icono,
    String? colorHex,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
