// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitStats _$HabitStatsFromJson(Map<String, dynamic> json) => _HabitStats(
  weeklyCompliancePercentage:
      (json['weeklyCompliancePercentage'] as num?)?.toDouble() ?? 0.0,
  monthlyCompliancePercentage:
      (json['monthlyCompliancePercentage'] as num?)?.toDouble() ?? 0.0,
  completedDays: (json['completedDays'] as num?)?.toInt() ?? 0,
  totalExpectedDays: (json['totalExpectedDays'] as num?)?.toInt() ?? 0,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  maxStreak: (json['maxStreak'] as num?)?.toInt() ?? 0,
  accumulatedPoints: (json['accumulatedPoints'] as num?)?.toInt() ?? 0,
  mostConsistentHabit: json['mostConsistentHabit'] == null
      ? null
      : InsightData.fromJson(
          json['mostConsistentHabit'] as Map<String, dynamic>,
        ),
  improvementOpportunity: json['improvementOpportunity'] == null
      ? null
      : InsightData.fromJson(
          json['improvementOpportunity'] as Map<String, dynamic>,
        ),
  smartInsight:
      json['smartInsight'] as String? ??
      'Continúa así para mantener tu consistencia.',
  weeklyProgress:
      (json['weeklyProgress'] as List<dynamic>?)
          ?.map((e) => ChartDataPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  monthlyProgress:
      (json['monthlyProgress'] as List<dynamic>?)
          ?.map((e) => ChartDataPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$HabitStatsToJson(_HabitStats instance) =>
    <String, dynamic>{
      'weeklyCompliancePercentage': instance.weeklyCompliancePercentage,
      'monthlyCompliancePercentage': instance.monthlyCompliancePercentage,
      'completedDays': instance.completedDays,
      'totalExpectedDays': instance.totalExpectedDays,
      'currentStreak': instance.currentStreak,
      'maxStreak': instance.maxStreak,
      'accumulatedPoints': instance.accumulatedPoints,
      'mostConsistentHabit': instance.mostConsistentHabit,
      'improvementOpportunity': instance.improvementOpportunity,
      'smartInsight': instance.smartInsight,
      'weeklyProgress': instance.weeklyProgress,
      'monthlyProgress': instance.monthlyProgress,
    };

_InsightData _$InsightDataFromJson(Map<String, dynamic> json) => _InsightData(
  name: json['name'] as String,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  rate: (json['rate'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$InsightDataToJson(_InsightData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'streak': instance.streak,
      'rate': instance.rate,
    };

_ChartDataPoint _$ChartDataPointFromJson(Map<String, dynamic> json) =>
    _ChartDataPoint(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$ChartDataPointToJson(_ChartDataPoint instance) =>
    <String, dynamic>{'label': instance.label, 'value': instance.value};
