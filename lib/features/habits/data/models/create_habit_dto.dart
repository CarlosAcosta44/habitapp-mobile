import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_habit_dto.freezed.dart';
part 'create_habit_dto.g.dart';

@freezed
abstract class CreateHabitDto with _$CreateHabitDto {
  const factory CreateHabitDto({
    required String nombre,
    String? descripcion,
    required String fechaInicio,
    String? fechaFin,
    required int puntos,
    double? metaDiaria,
    String? unidadMedida,
    required String idCategoria,
  }) = _CreateHabitDto;

  factory CreateHabitDto.fromJson(Map<String, dynamic> json) =>
      _$CreateHabitDtoFromJson(json);
}
