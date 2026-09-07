import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_record_model.freezed.dart';
part 'habit_record_model.g.dart';

@freezed
abstract class HabitRecordModel with _$HabitRecordModel {
  const factory HabitRecordModel({
    required String fecha,
    required bool completado,
    required double progresoActual,
    required int puntosGanados,
  }) = _HabitRecordModel;

  factory HabitRecordModel.fromJson(Map<String, dynamic> json) =>
      _$HabitRecordModelFromJson(json);
}
