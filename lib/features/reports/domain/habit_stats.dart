import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_stats.freezed.dart';
part 'habit_stats.g.dart';

@freezed
abstract class HabitStats with _$HabitStats {
  const factory HabitStats({
    @Default(0.0) double weeklyCompliancePercentage,
    @Default(0.0) double monthlyCompliancePercentage,
    @Default(0) int completedDays,
    @Default(0) int totalExpectedDays,
    @Default(0) int currentStreak,
    @Default(0) int maxStreak,
    @Default(0) int accumulatedPoints,

    // Insights adicionales
    InsightData? mostConsistentHabit,
    InsightData? improvementOpportunity,
    @Default('Continúa así para mantener tu consistencia.') String smartInsight,

    // Data structures for fl_chart and UI
    @Default([]) List<ChartDataPoint> weeklyProgress,
    @Default([]) List<ChartDataPoint> monthlyProgress,
  }) = _HabitStats;

  factory HabitStats.fromJson(Map<String, dynamic> json) =>
      _$HabitStatsFromJson(json);
}

@freezed
abstract class InsightData with _$InsightData {
  const factory InsightData({
    required String name,
    @Default(0) int streak,
    @Default(0) double rate,
  }) = _InsightData;

  factory InsightData.fromJson(Map<String, dynamic> json) =>
      _$InsightDataFromJson(json);
}

@freezed
abstract class ChartDataPoint with _$ChartDataPoint {
  const factory ChartDataPoint({required String label, required double value}) =
      _ChartDataPoint;

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) =>
      _$ChartDataPointFromJson(json);
}
