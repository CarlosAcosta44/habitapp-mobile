// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitRecordModel {

 String get fecha; bool get completado; double get progresoActual; int get puntosGanados;
/// Create a copy of HabitRecordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitRecordModelCopyWith<HabitRecordModel> get copyWith => _$HabitRecordModelCopyWithImpl<HabitRecordModel>(this as HabitRecordModel, _$identity);

  /// Serializes this HabitRecordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitRecordModel&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.completado, completado) || other.completado == completado)&&(identical(other.progresoActual, progresoActual) || other.progresoActual == progresoActual)&&(identical(other.puntosGanados, puntosGanados) || other.puntosGanados == puntosGanados));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fecha,completado,progresoActual,puntosGanados);

@override
String toString() {
  return 'HabitRecordModel(fecha: $fecha, completado: $completado, progresoActual: $progresoActual, puntosGanados: $puntosGanados)';
}


}

/// @nodoc
abstract mixin class $HabitRecordModelCopyWith<$Res>  {
  factory $HabitRecordModelCopyWith(HabitRecordModel value, $Res Function(HabitRecordModel) _then) = _$HabitRecordModelCopyWithImpl;
@useResult
$Res call({
 String fecha, bool completado, double progresoActual, int puntosGanados
});




}
/// @nodoc
class _$HabitRecordModelCopyWithImpl<$Res>
    implements $HabitRecordModelCopyWith<$Res> {
  _$HabitRecordModelCopyWithImpl(this._self, this._then);

  final HabitRecordModel _self;
  final $Res Function(HabitRecordModel) _then;

/// Create a copy of HabitRecordModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fecha = null,Object? completado = null,Object? progresoActual = null,Object? puntosGanados = null,}) {
  return _then(HabitRecordModel(
fecha: null == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String,completado: null == completado ? _self.completado : completado // ignore: cast_nullable_to_non_nullable
as bool,progresoActual: null == progresoActual ? _self.progresoActual : progresoActual // ignore: cast_nullable_to_non_nullable
as double,puntosGanados: null == puntosGanados ? _self.puntosGanados : puntosGanados // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitRecordModel].
extension HabitRecordModelPatterns on HabitRecordModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitRecordModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitRecordModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitRecordModel value)  $default,){
final _that = this;
switch (_that) {
case _HabitRecordModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitRecordModel value)?  $default,){
final _that = this;
switch (_that) {
case _HabitRecordModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fecha,  bool completado,  double progresoActual,  int puntosGanados)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitRecordModel() when $default != null:
return $default(_that.fecha,_that.completado,_that.progresoActual,_that.puntosGanados);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fecha,  bool completado,  double progresoActual,  int puntosGanados)  $default,) {final _that = this;
switch (_that) {
case _HabitRecordModel():
return $default(_that.fecha,_that.completado,_that.progresoActual,_that.puntosGanados);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fecha,  bool completado,  double progresoActual,  int puntosGanados)?  $default,) {final _that = this;
switch (_that) {
case _HabitRecordModel() when $default != null:
return $default(_that.fecha,_that.completado,_that.progresoActual,_that.puntosGanados);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitRecordModel implements HabitRecordModel {
  const _HabitRecordModel({required this.fecha, required this.completado, required this.progresoActual, required this.puntosGanados});
  factory _HabitRecordModel.fromJson(Map<String, dynamic> json) => _$HabitRecordModelFromJson(json);

@override final  String fecha;
@override final  bool completado;
@override final  double progresoActual;
@override final  int puntosGanados;

/// Create a copy of HabitRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitRecordModelCopyWith<_HabitRecordModel> get copyWith => __$HabitRecordModelCopyWithImpl<_HabitRecordModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitRecordModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitRecordModel&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.completado, completado) || other.completado == completado)&&(identical(other.progresoActual, progresoActual) || other.progresoActual == progresoActual)&&(identical(other.puntosGanados, puntosGanados) || other.puntosGanados == puntosGanados));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fecha,completado,progresoActual,puntosGanados);

@override
String toString() {
  return 'HabitRecordModel(fecha: $fecha, completado: $completado, progresoActual: $progresoActual, puntosGanados: $puntosGanados)';
}


}

/// @nodoc
abstract mixin class _$HabitRecordModelCopyWith<$Res> implements $HabitRecordModelCopyWith<$Res> {
  factory _$HabitRecordModelCopyWith(_HabitRecordModel value, $Res Function(_HabitRecordModel) _then) = __$HabitRecordModelCopyWithImpl;
@override @useResult
$Res call({
 String fecha, bool completado, double progresoActual, int puntosGanados
});




}
/// @nodoc
class __$HabitRecordModelCopyWithImpl<$Res>
    implements _$HabitRecordModelCopyWith<$Res> {
  __$HabitRecordModelCopyWithImpl(this._self, this._then);

  final _HabitRecordModel _self;
  final $Res Function(_HabitRecordModel) _then;

/// Create a copy of HabitRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fecha = null,Object? completado = null,Object? progresoActual = null,Object? puntosGanados = null,}) {
  return _then(_HabitRecordModel(
fecha: null == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as String,completado: null == completado ? _self.completado : completado // ignore: cast_nullable_to_non_nullable
as bool,progresoActual: null == progresoActual ? _self.progresoActual : progresoActual // ignore: cast_nullable_to_non_nullable
as double,puntosGanados: null == puntosGanados ? _self.puntosGanados : puntosGanados // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
