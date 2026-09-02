import 'package:freezed_annotation/freezed_annotation.dart';
import 'category_model.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

@freezed
abstract class HabitModel with _$HabitModel {
  const factory HabitModel({
    required String id,
    required String nombre,
    String? descripcion,
    @Default(10) int puntos,
    @Default(1.0) double metaDiaria,
    @Default('veces') String unidadMedida,
    String? idCategoria,
    CategoryModel? categoria,
    @Default(false) bool completadoHoy,
    @Default(0.0) double progresoHoy,
    @Default(0) int rachaActual,
    String? fechaInicio,
    String? fechaFin,
    @Default([1, 2, 3, 4, 5, 6, 7]) List<int> diasSemana,
  }) = _HabitModel;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);
}
