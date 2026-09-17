// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitStats {

 double get weeklyCompliancePercentage; double get monthlyCompliancePercentage; int get completedDays; int get totalExpectedDays; int get currentStreak; int get maxStreak; int get accumulatedPoints; InsightData? get mostConsistentHabit; InsightData? get improvementOpportunity; String get smartInsight; List<ChartDataPoint> get weeklyProgress; List<ChartDataPoint> get monthlyProgress;
/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitStatsCopyWith<HabitStats> get copyWith => _$HabitStatsCopyWithImpl<HabitStats>(this as HabitStats, _$identity);

  /// Serializes this HabitStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitStats&&(identical(other.weeklyCompliancePercentage, weeklyCompliancePercentage) || other.weeklyCompliancePercentage == weeklyCompliancePercentage)&&(identical(other.monthlyCompliancePercentage, monthlyCompliancePercentage) || other.monthlyCompliancePercentage == monthlyCompliancePercentage)&&(identical(other.completedDays, completedDays) || other.completedDays == completedDays)&&(identical(other.totalExpectedDays, totalExpectedDays) || other.totalExpectedDays == totalExpectedDays)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.maxStreak, maxStreak) || other.maxStreak == maxStreak)&&(identical(other.accumulatedPoints, accumulatedPoints) || other.accumulatedPoints == accumulatedPoints)&&(identical(other.mostConsistentHabit, mostConsistentHabit) || other.mostConsistentHabit == mostConsistentHabit)&&(identical(other.improvementOpportunity, improvementOpportunity) || other.improvementOpportunity == improvementOpportunity)&&(identical(other.smartInsight, smartInsight) || other.smartInsight == smartInsight)&&const DeepCollectionEquality().equals(other.weeklyProgress, weeklyProgress)&&const DeepCollectionEquality().equals(other.monthlyProgress, monthlyProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weeklyCompliancePercentage,monthlyCompliancePercentage,completedDays,totalExpectedDays,currentStreak,maxStreak,accumulatedPoints,mostConsistentHabit,improvementOpportunity,smartInsight,const DeepCollectionEquality().hash(weeklyProgress),const DeepCollectionEquality().hash(monthlyProgress));

@override
String toString() {
  return 'HabitStats(weeklyCompliancePercentage: $weeklyCompliancePercentage, monthlyCompliancePercentage: $monthlyCompliancePercentage, completedDays: $completedDays, totalExpectedDays: $totalExpectedDays, currentStreak: $currentStreak, maxStreak: $maxStreak, accumulatedPoints: $accumulatedPoints, mostConsistentHabit: $mostConsistentHabit, improvementOpportunity: $improvementOpportunity, smartInsight: $smartInsight, weeklyProgress: $weeklyProgress, monthlyProgress: $monthlyProgress)';
}


}

/// @nodoc
abstract mixin class $HabitStatsCopyWith<$Res>  {
  factory $HabitStatsCopyWith(HabitStats value, $Res Function(HabitStats) _then) = _$HabitStatsCopyWithImpl;
@useResult
$Res call({
 double weeklyCompliancePercentage, double monthlyCompliancePercentage, int completedDays, int totalExpectedDays, int currentStreak, int maxStreak, int accumulatedPoints, InsightData? mostConsistentHabit, InsightData? improvementOpportunity, String smartInsight, List<ChartDataPoint> weeklyProgress, List<ChartDataPoint> monthlyProgress
});


$InsightDataCopyWith<$Res>? get mostConsistentHabit;$InsightDataCopyWith<$Res>? get improvementOpportunity;

}
/// @nodoc
class _$HabitStatsCopyWithImpl<$Res>
    implements $HabitStatsCopyWith<$Res> {
  _$HabitStatsCopyWithImpl(this._self, this._then);

  final HabitStats _self;
  final $Res Function(HabitStats) _then;

/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weeklyCompliancePercentage = null,Object? monthlyCompliancePercentage = null,Object? completedDays = null,Object? totalExpectedDays = null,Object? currentStreak = null,Object? maxStreak = null,Object? accumulatedPoints = null,Object? mostConsistentHabit = freezed,Object? improvementOpportunity = freezed,Object? smartInsight = null,Object? weeklyProgress = null,Object? monthlyProgress = null,}) {
  return _then(HabitStats(
weeklyCompliancePercentage: null == weeklyCompliancePercentage ? _self.weeklyCompliancePercentage : weeklyCompliancePercentage // ignore: cast_nullable_to_non_nullable
as double,monthlyCompliancePercentage: null == monthlyCompliancePercentage ? _self.monthlyCompliancePercentage : monthlyCompliancePercentage // ignore: cast_nullable_to_non_nullable
as double,completedDays: null == completedDays ? _self.completedDays : completedDays // ignore: cast_nullable_to_non_nullable
as int,totalExpectedDays: null == totalExpectedDays ? _self.totalExpectedDays : totalExpectedDays // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,maxStreak: null == maxStreak ? _self.maxStreak : maxStreak // ignore: cast_nullable_to_non_nullable
as int,accumulatedPoints: null == accumulatedPoints ? _self.accumulatedPoints : accumulatedPoints // ignore: cast_nullable_to_non_nullable
as int,mostConsistentHabit: freezed == mostConsistentHabit ? _self.mostConsistentHabit : mostConsistentHabit // ignore: cast_nullable_to_non_nullable
as InsightData?,improvementOpportunity: freezed == improvementOpportunity ? _self.improvementOpportunity : improvementOpportunity // ignore: cast_nullable_to_non_nullable
as InsightData?,smartInsight: null == smartInsight ? _self.smartInsight : smartInsight // ignore: cast_nullable_to_non_nullable
as String,weeklyProgress: null == weeklyProgress ? _self.weeklyProgress : weeklyProgress // ignore: cast_nullable_to_non_nullable
as List<ChartDataPoint>,monthlyProgress: null == monthlyProgress ? _self.monthlyProgress : monthlyProgress // ignore: cast_nullable_to_non_nullable
as List<ChartDataPoint>,
  ));
}
/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InsightDataCopyWith<$Res>? get mostConsistentHabit {
    if (_self.mostConsistentHabit == null) {
    return null;
  }

  return $InsightDataCopyWith<$Res>(_self.mostConsistentHabit!, (value) {
    return _then(_self.copyWith(mostConsistentHabit: value));
  });
}/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InsightDataCopyWith<$Res>? get improvementOpportunity {
    if (_self.improvementOpportunity == null) {
    return null;
  }

  return $InsightDataCopyWith<$Res>(_self.improvementOpportunity!, (value) {
    return _then(_self.copyWith(improvementOpportunity: value));
  });
}
}


/// Adds pattern-matching-related methods to [HabitStats].
extension HabitStatsPatterns on HabitStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitStats value)  $default,){
final _that = this;
switch (_that) {
case _HabitStats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitStats value)?  $default,){
final _that = this;
switch (_that) {
case _HabitStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double weeklyCompliancePercentage,  double monthlyCompliancePercentage,  int completedDays,  int totalExpectedDays,  int currentStreak,  int maxStreak,  int accumulatedPoints,  InsightData? mostConsistentHabit,  InsightData? improvementOpportunity,  String smartInsight,  List<ChartDataPoint> weeklyProgress,  List<ChartDataPoint> monthlyProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitStats() when $default != null:
return $default(_that.weeklyCompliancePercentage,_that.monthlyCompliancePercentage,_that.completedDays,_that.totalExpectedDays,_that.currentStreak,_that.maxStreak,_that.accumulatedPoints,_that.mostConsistentHabit,_that.improvementOpportunity,_that.smartInsight,_that.weeklyProgress,_that.monthlyProgress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double weeklyCompliancePercentage,  double monthlyCompliancePercentage,  int completedDays,  int totalExpectedDays,  int currentStreak,  int maxStreak,  int accumulatedPoints,  InsightData? mostConsistentHabit,  InsightData? improvementOpportunity,  String smartInsight,  List<ChartDataPoint> weeklyProgress,  List<ChartDataPoint> monthlyProgress)  $default,) {final _that = this;
switch (_that) {
case _HabitStats():
return $default(_that.weeklyCompliancePercentage,_that.monthlyCompliancePercentage,_that.completedDays,_that.totalExpectedDays,_that.currentStreak,_that.maxStreak,_that.accumulatedPoints,_that.mostConsistentHabit,_that.improvementOpportunity,_that.smartInsight,_that.weeklyProgress,_that.monthlyProgress);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double weeklyCompliancePercentage,  double monthlyCompliancePercentage,  int completedDays,  int totalExpectedDays,  int currentStreak,  int maxStreak,  int accumulatedPoints,  InsightData? mostConsistentHabit,  InsightData? improvementOpportunity,  String smartInsight,  List<ChartDataPoint> weeklyProgress,  List<ChartDataPoint> monthlyProgress)?  $default,) {final _that = this;
switch (_that) {
case _HabitStats() when $default != null:
return $default(_that.weeklyCompliancePercentage,_that.monthlyCompliancePercentage,_that.completedDays,_that.totalExpectedDays,_that.currentStreak,_that.maxStreak,_that.accumulatedPoints,_that.mostConsistentHabit,_that.improvementOpportunity,_that.smartInsight,_that.weeklyProgress,_that.monthlyProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitStats implements HabitStats {
  const _HabitStats({this.weeklyCompliancePercentage = 0.0, this.monthlyCompliancePercentage = 0.0, this.completedDays = 0, this.totalExpectedDays = 0, this.currentStreak = 0, this.maxStreak = 0, this.accumulatedPoints = 0, this.mostConsistentHabit, this.improvementOpportunity, this.smartInsight = 'Continúa así para mantener tu consistencia.',  List<ChartDataPoint> weeklyProgress = const [],  List<ChartDataPoint> monthlyProgress = const []}): _weeklyProgress = weeklyProgress,_monthlyProgress = monthlyProgress;
  factory _HabitStats.fromJson(Map<String, dynamic> json) => _$HabitStatsFromJson(json);

@override@JsonKey() final  double weeklyCompliancePercentage;
@override@JsonKey() final  double monthlyCompliancePercentage;
@override@JsonKey() final  int completedDays;
@override@JsonKey() final  int totalExpectedDays;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int maxStreak;
@override@JsonKey() final  int accumulatedPoints;
@override final  InsightData? mostConsistentHabit;
@override final  InsightData? improvementOpportunity;
@override@JsonKey() final  String smartInsight;
 final  List<ChartDataPoint> _weeklyProgress;
@override@JsonKey() List<ChartDataPoint> get weeklyProgress {
  if (_weeklyProgress is EqualUnmodifiableListView) return _weeklyProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeklyProgress);
}

 final  List<ChartDataPoint> _monthlyProgress;
@override@JsonKey() List<ChartDataPoint> get monthlyProgress {
  if (_monthlyProgress is EqualUnmodifiableListView) return _monthlyProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthlyProgress);
}


/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitStatsCopyWith<_HabitStats> get copyWith => __$HabitStatsCopyWithImpl<_HabitStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitStats&&(identical(other.weeklyCompliancePercentage, weeklyCompliancePercentage) || other.weeklyCompliancePercentage == weeklyCompliancePercentage)&&(identical(other.monthlyCompliancePercentage, monthlyCompliancePercentage) || other.monthlyCompliancePercentage == monthlyCompliancePercentage)&&(identical(other.completedDays, completedDays) || other.completedDays == completedDays)&&(identical(other.totalExpectedDays, totalExpectedDays) || other.totalExpectedDays == totalExpectedDays)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.maxStreak, maxStreak) || other.maxStreak == maxStreak)&&(identical(other.accumulatedPoints, accumulatedPoints) || other.accumulatedPoints == accumulatedPoints)&&(identical(other.mostConsistentHabit, mostConsistentHabit) || other.mostConsistentHabit == mostConsistentHabit)&&(identical(other.improvementOpportunity, improvementOpportunity) || other.improvementOpportunity == improvementOpportunity)&&(identical(other.smartInsight, smartInsight) || other.smartInsight == smartInsight)&&const DeepCollectionEquality().equals(other._weeklyProgress, _weeklyProgress)&&const DeepCollectionEquality().equals(other._monthlyProgress, _monthlyProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weeklyCompliancePercentage,monthlyCompliancePercentage,completedDays,totalExpectedDays,currentStreak,maxStreak,accumulatedPoints,mostConsistentHabit,improvementOpportunity,smartInsight,const DeepCollectionEquality().hash(_weeklyProgress),const DeepCollectionEquality().hash(_monthlyProgress));

@override
String toString() {
  return 'HabitStats(weeklyCompliancePercentage: $weeklyCompliancePercentage, monthlyCompliancePercentage: $monthlyCompliancePercentage, completedDays: $completedDays, totalExpectedDays: $totalExpectedDays, currentStreak: $currentStreak, maxStreak: $maxStreak, accumulatedPoints: $accumulatedPoints, mostConsistentHabit: $mostConsistentHabit, improvementOpportunity: $improvementOpportunity, smartInsight: $smartInsight, weeklyProgress: $weeklyProgress, monthlyProgress: $monthlyProgress)';
}


}

/// @nodoc
abstract mixin class _$HabitStatsCopyWith<$Res> implements $HabitStatsCopyWith<$Res> {
  factory _$HabitStatsCopyWith(_HabitStats value, $Res Function(_HabitStats) _then) = __$HabitStatsCopyWithImpl;
@override @useResult
$Res call({
 double weeklyCompliancePercentage, double monthlyCompliancePercentage, int completedDays, int totalExpectedDays, int currentStreak, int maxStreak, int accumulatedPoints, InsightData? mostConsistentHabit, InsightData? improvementOpportunity, String smartInsight, List<ChartDataPoint> weeklyProgress, List<ChartDataPoint> monthlyProgress
});


@override $InsightDataCopyWith<$Res>? get mostConsistentHabit;@override $InsightDataCopyWith<$Res>? get improvementOpportunity;

}
/// @nodoc
class __$HabitStatsCopyWithImpl<$Res>
    implements _$HabitStatsCopyWith<$Res> {
  __$HabitStatsCopyWithImpl(this._self, this._then);

  final _HabitStats _self;
  final $Res Function(_HabitStats) _then;

/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weeklyCompliancePercentage = null,Object? monthlyCompliancePercentage = null,Object? completedDays = null,Object? totalExpectedDays = null,Object? currentStreak = null,Object? maxStreak = null,Object? accumulatedPoints = null,Object? mostConsistentHabit = freezed,Object? improvementOpportunity = freezed,Object? smartInsight = null,Object? weeklyProgress = null,Object? monthlyProgress = null,}) {
  return _then(_HabitStats(
weeklyCompliancePercentage: null == weeklyCompliancePercentage ? _self.weeklyCompliancePercentage : weeklyCompliancePercentage // ignore: cast_nullable_to_non_nullable
as double,monthlyCompliancePercentage: null == monthlyCompliancePercentage ? _self.monthlyCompliancePercentage : monthlyCompliancePercentage // ignore: cast_nullable_to_non_nullable
as double,completedDays: null == completedDays ? _self.completedDays : completedDays // ignore: cast_nullable_to_non_nullable
as int,totalExpectedDays: null == totalExpectedDays ? _self.totalExpectedDays : totalExpectedDays // ignore: cast_nullable_to_non_nullable
as int,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,maxStreak: null == maxStreak ? _self.maxStreak : maxStreak // ignore: cast_nullable_to_non_nullable
as int,accumulatedPoints: null == accumulatedPoints ? _self.accumulatedPoints : accumulatedPoints // ignore: cast_nullable_to_non_nullable
as int,mostConsistentHabit: freezed == mostConsistentHabit ? _self.mostConsistentHabit : mostConsistentHabit // ignore: cast_nullable_to_non_nullable
as InsightData?,improvementOpportunity: freezed == improvementOpportunity ? _self.improvementOpportunity : improvementOpportunity // ignore: cast_nullable_to_non_nullable
as InsightData?,smartInsight: null == smartInsight ? _self.smartInsight : smartInsight // ignore: cast_nullable_to_non_nullable
as String,weeklyProgress: null == weeklyProgress ? _self._weeklyProgress : weeklyProgress // ignore: cast_nullable_to_non_nullable
as List<ChartDataPoint>,monthlyProgress: null == monthlyProgress ? _self._monthlyProgress : monthlyProgress // ignore: cast_nullable_to_non_nullable
as List<ChartDataPoint>,
  ));
}

/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InsightDataCopyWith<$Res>? get mostConsistentHabit {
    if (_self.mostConsistentHabit == null) {
    return null;
  }

  return $InsightDataCopyWith<$Res>(_self.mostConsistentHabit!, (value) {
    return _then(_self.copyWith(mostConsistentHabit: value));
  });
}/// Create a copy of HabitStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InsightDataCopyWith<$Res>? get improvementOpportunity {
    if (_self.improvementOpportunity == null) {
    return null;
  }

  return $InsightDataCopyWith<$Res>(_self.improvementOpportunity!, (value) {
    return _then(_self.copyWith(improvementOpportunity: value));
  });
}
}


/// @nodoc
mixin _$InsightData {

 String get name; int get streak; double get rate;
/// Create a copy of InsightData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsightDataCopyWith<InsightData> get copyWith => _$InsightDataCopyWithImpl<InsightData>(this as InsightData, _$identity);

  /// Serializes this InsightData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsightData&&(identical(other.name, name) || other.name == name)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,streak,rate);

@override
String toString() {
  return 'InsightData(name: $name, streak: $streak, rate: $rate)';
}


}

/// @nodoc
abstract mixin class $InsightDataCopyWith<$Res>  {
  factory $InsightDataCopyWith(InsightData value, $Res Function(InsightData) _then) = _$InsightDataCopyWithImpl;
@useResult
$Res call({
 String name, int streak, double rate
});




}
/// @nodoc
class _$InsightDataCopyWithImpl<$Res>
    implements $InsightDataCopyWith<$Res> {
  _$InsightDataCopyWithImpl(this._self, this._then);

  final InsightData _self;
  final $Res Function(InsightData) _then;

/// Create a copy of InsightData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? streak = null,Object? rate = null,}) {
  return _then(InsightData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InsightData].
extension InsightDataPatterns on InsightData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsightData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsightData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsightData value)  $default,){
final _that = this;
switch (_that) {
case _InsightData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsightData value)?  $default,){
final _that = this;
switch (_that) {
case _InsightData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int streak,  double rate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsightData() when $default != null:
return $default(_that.name,_that.streak,_that.rate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int streak,  double rate)  $default,) {final _that = this;
switch (_that) {
case _InsightData():
return $default(_that.name,_that.streak,_that.rate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int streak,  double rate)?  $default,) {final _that = this;
switch (_that) {
case _InsightData() when $default != null:
return $default(_that.name,_that.streak,_that.rate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InsightData implements InsightData {
  const _InsightData({required this.name, this.streak = 0, this.rate = 0});
  factory _InsightData.fromJson(Map<String, dynamic> json) => _$InsightDataFromJson(json);

@override final  String name;
@override@JsonKey() final  int streak;
@override@JsonKey() final  double rate;

/// Create a copy of InsightData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsightDataCopyWith<_InsightData> get copyWith => __$InsightDataCopyWithImpl<_InsightData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsightDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsightData&&(identical(other.name, name) || other.name == name)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,streak,rate);

@override
String toString() {
  return 'InsightData(name: $name, streak: $streak, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$InsightDataCopyWith<$Res> implements $InsightDataCopyWith<$Res> {
  factory _$InsightDataCopyWith(_InsightData value, $Res Function(_InsightData) _then) = __$InsightDataCopyWithImpl;
@override @useResult
$Res call({
 String name, int streak, double rate
});




}
/// @nodoc
class __$InsightDataCopyWithImpl<$Res>
    implements _$InsightDataCopyWith<$Res> {
  __$InsightDataCopyWithImpl(this._self, this._then);

  final _InsightData _self;
  final $Res Function(_InsightData) _then;

/// Create a copy of InsightData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? streak = null,Object? rate = null,}) {
  return _then(_InsightData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ChartDataPoint {

 String get label; double get value;
/// Create a copy of ChartDataPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChartDataPointCopyWith<ChartDataPoint> get copyWith => _$ChartDataPointCopyWithImpl<ChartDataPoint>(this as ChartDataPoint, _$identity);

  /// Serializes this ChartDataPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartDataPoint&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value);

@override
String toString() {
  return 'ChartDataPoint(label: $label, value: $value)';
}


}

/// @nodoc
abstract mixin class $ChartDataPointCopyWith<$Res>  {
  factory $ChartDataPointCopyWith(ChartDataPoint value, $Res Function(ChartDataPoint) _then) = _$ChartDataPointCopyWithImpl;
@useResult
$Res call({
 String label, double value
});




}
/// @nodoc
class _$ChartDataPointCopyWithImpl<$Res>
    implements $ChartDataPointCopyWith<$Res> {
  _$ChartDataPointCopyWithImpl(this._self, this._then);

  final ChartDataPoint _self;
  final $Res Function(ChartDataPoint) _then;

/// Create a copy of ChartDataPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,}) {
  return _then(ChartDataPoint(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ChartDataPoint].
extension ChartDataPointPatterns on ChartDataPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChartDataPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChartDataPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChartDataPoint value)  $default,){
final _that = this;
switch (_that) {
case _ChartDataPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChartDataPoint value)?  $default,){
final _that = this;
switch (_that) {
case _ChartDataPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChartDataPoint() when $default != null:
return $default(_that.label,_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double value)  $default,) {final _that = this;
switch (_that) {
case _ChartDataPoint():
return $default(_that.label,_that.value);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double value)?  $default,) {final _that = this;
switch (_that) {
case _ChartDataPoint() when $default != null:
return $default(_that.label,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChartDataPoint implements ChartDataPoint {
  const _ChartDataPoint({required this.label, required this.value});
  factory _ChartDataPoint.fromJson(Map<String, dynamic> json) => _$ChartDataPointFromJson(json);

@override final  String label;
@override final  double value;

/// Create a copy of ChartDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChartDataPointCopyWith<_ChartDataPoint> get copyWith => __$ChartDataPointCopyWithImpl<_ChartDataPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChartDataPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChartDataPoint&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value);

@override
String toString() {
  return 'ChartDataPoint(label: $label, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ChartDataPointCopyWith<$Res> implements $ChartDataPointCopyWith<$Res> {
  factory _$ChartDataPointCopyWith(_ChartDataPoint value, $Res Function(_ChartDataPoint) _then) = __$ChartDataPointCopyWithImpl;
@override @useResult
$Res call({
 String label, double value
});




}
/// @nodoc
class __$ChartDataPointCopyWithImpl<$Res>
    implements _$ChartDataPointCopyWith<$Res> {
  __$ChartDataPointCopyWithImpl(this._self, this._then);

  final _ChartDataPoint _self;
  final $Res Function(_ChartDataPoint) _then;

/// Create a copy of ChartDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,}) {
  return _then(_ChartDataPoint(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
