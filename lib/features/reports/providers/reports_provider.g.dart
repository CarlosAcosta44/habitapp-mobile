// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(habitStats)
final habitStatsProvider = HabitStatsFamily._();

final class HabitStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<HabitStats>,
          HabitStats,
          FutureOr<HabitStats>
        >
    with $FutureModifier<HabitStats>, $FutureProvider<HabitStats> {
  HabitStatsProvider._({
    required HabitStatsFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'habitStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$habitStatsHash();

  @override
  String toString() {
    return r'habitStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<HabitStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<HabitStats> create(Ref ref) {
    final argument = this.argument as String?;
    return habitStats(ref, targetUserId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HabitStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$habitStatsHash() => r'e725b3a4ea47776dc30b028f4065c1b3e7f9a4fb';

final class HabitStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<HabitStats>, String?> {
  HabitStatsFamily._()
    : super(
        retry: null,
        name: r'habitStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HabitStatsProvider call({String? targetUserId}) =>
      HabitStatsProvider._(argument: targetUserId, from: this);

  @override
  String toString() => r'habitStatsProvider';
}

@ProviderFor(weeklyProgressChartData)
final weeklyProgressChartDataProvider = WeeklyProgressChartDataFamily._();

final class WeeklyProgressChartDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FlSpot>>,
          List<FlSpot>,
          FutureOr<List<FlSpot>>
        >
    with $FutureModifier<List<FlSpot>>, $FutureProvider<List<FlSpot>> {
  WeeklyProgressChartDataProvider._({
    required WeeklyProgressChartDataFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'weeklyProgressChartDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weeklyProgressChartDataHash();

  @override
  String toString() {
    return r'weeklyProgressChartDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<FlSpot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FlSpot>> create(Ref ref) {
    final argument = this.argument as String?;
    return weeklyProgressChartData(ref, targetUserId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyProgressChartDataProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weeklyProgressChartDataHash() =>
    r'9cceee17776080afa123d0a958029b1a59f489c2';

final class WeeklyProgressChartDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<FlSpot>>, String?> {
  WeeklyProgressChartDataFamily._()
    : super(
        retry: null,
        name: r'weeklyProgressChartDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WeeklyProgressChartDataProvider call({String? targetUserId}) =>
      WeeklyProgressChartDataProvider._(argument: targetUserId, from: this);

  @override
  String toString() => r'weeklyProgressChartDataProvider';
}

@ProviderFor(monthlyProgressBarData)
final monthlyProgressBarDataProvider = MonthlyProgressBarDataFamily._();

final class MonthlyProgressBarDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BarChartGroupData>>,
          List<BarChartGroupData>,
          FutureOr<List<BarChartGroupData>>
        >
    with
        $FutureModifier<List<BarChartGroupData>>,
        $FutureProvider<List<BarChartGroupData>> {
  MonthlyProgressBarDataProvider._({
    required MonthlyProgressBarDataFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'monthlyProgressBarDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyProgressBarDataHash();

  @override
  String toString() {
    return r'monthlyProgressBarDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BarChartGroupData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BarChartGroupData>> create(Ref ref) {
    final argument = this.argument as String?;
    return monthlyProgressBarData(ref, targetUserId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyProgressBarDataProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyProgressBarDataHash() =>
    r'3bf323f79ab436c55830ac3633ef1b560f5d7a12';

final class MonthlyProgressBarDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BarChartGroupData>>, String?> {
  MonthlyProgressBarDataFamily._()
    : super(
        retry: null,
        name: r'monthlyProgressBarDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MonthlyProgressBarDataProvider call({String? targetUserId}) =>
      MonthlyProgressBarDataProvider._(argument: targetUserId, from: this);

  @override
  String toString() => r'monthlyProgressBarDataProvider';
}
