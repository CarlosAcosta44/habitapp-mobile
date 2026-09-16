// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(habitStats)
final habitStatsProvider = HabitStatsProvider._();

final class HabitStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<HabitStats>,
          HabitStats,
          FutureOr<HabitStats>
        >
    with $FutureModifier<HabitStats>, $FutureProvider<HabitStats> {
  HabitStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'habitStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$habitStatsHash();

  @$internal
  @override
  $FutureProviderElement<HabitStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<HabitStats> create(Ref ref) {
    return habitStats(ref);
  }
}

String _$habitStatsHash() => r'eb4d35e6d8d12ca41a67d8b6d3d708c0823f6575';

@ProviderFor(weeklyProgressChartData)
final weeklyProgressChartDataProvider = WeeklyProgressChartDataProvider._();

final class WeeklyProgressChartDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FlSpot>>,
          List<FlSpot>,
          FutureOr<List<FlSpot>>
        >
    with $FutureModifier<List<FlSpot>>, $FutureProvider<List<FlSpot>> {
  WeeklyProgressChartDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyProgressChartDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyProgressChartDataHash();

  @$internal
  @override
  $FutureProviderElement<List<FlSpot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FlSpot>> create(Ref ref) {
    return weeklyProgressChartData(ref);
  }
}

String _$weeklyProgressChartDataHash() =>
    r'ef069d557374e211344eb9960c9ebfa2ced57a85';

@ProviderFor(monthlyProgressBarData)
final monthlyProgressBarDataProvider = MonthlyProgressBarDataProvider._();

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
  MonthlyProgressBarDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyProgressBarDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyProgressBarDataHash();

  @$internal
  @override
  $FutureProviderElement<List<BarChartGroupData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BarChartGroupData>> create(Ref ref) {
    return monthlyProgressBarData(ref);
  }
}

String _$monthlyProgressBarDataHash() =>
    r'bcd4cc6098015d69f5d8a8a95cb65d7ad1d70403';
