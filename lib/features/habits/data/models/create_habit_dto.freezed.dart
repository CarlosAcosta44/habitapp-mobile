// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_habit_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateHabitDto {

 String get nombre; String? get descripcion; String get fechaInicio; String? get fechaFin; int get puntos; double? get metaDiaria; String? get unidadMedida; String get idCategoria; List<int> get diasSemana;
/// Create a copy of CreateHabitDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateHabitDtoCopyWith<CreateHabitDto> get copyWith => _$CreateHabitDtoCopyWithImpl<CreateHabitDto>(this as CreateHabitDto, _$identity);

  /// Serializes this CreateHabitDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateHabitDto&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&(identical(other.puntos, puntos) || other.puntos == puntos)&&(identical(other.metaDiaria, metaDiaria) || other.metaDiaria == metaDiaria)&&(identical(other.unidadMedida, unidadMedida) || other.unidadMedida == unidadMedida)&&(identical(other.idCategoria, idCategoria) || other.idCategoria == idCategoria)&&DeepCollectionEquality().equals(other.diasSemana, diasSemana));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nombre,descripcion,fechaInicio,fechaFin,puntos,metaDiaria,unidadMedida,idCategoria,DeepCollectionEquality().hash(diasSemana));

@override
String toString() {
  return 'CreateHabitDto(nombre: $nombre, descripcion: $descripcion, fechaInicio: $fechaInicio, fechaFin: $fechaFin, puntos: $puntos, metaDiaria: $metaDiaria, unidadMedida: $unidadMedida, idCategoria: $idCategoria, diasSemana: $diasSemana)';
}


}

/// @nodoc
abstract mixin class $CreateHabitDtoCopyWith<$Res>  {
  factory $CreateHabitDtoCopyWith(CreateHabitDto value, $Res Function(CreateHabitDto) _then) = _$CreateHabitDtoCopyWithImpl;
@useResult
$Res call({
 String nombre, String? descripcion, String fechaInicio, String? fechaFin, int puntos, double? metaDiaria, String? unidadMedida, String idCategoria, List<int> diasSemana
});




}
/// @nodoc
class _$CreateHabitDtoCopyWithImpl<$Res>
    implements $CreateHabitDtoCopyWith<$Res> {
  _$CreateHabitDtoCopyWithImpl(this._self, this._then);

  final CreateHabitDto _self;
  final $Res Function(CreateHabitDto) _then;

/// Create a copy of CreateHabitDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nombre = null,Object? descripcion = freezed,Object? fechaInicio = null,Object? fechaFin = freezed,Object? puntos = null,Object? metaDiaria = freezed,Object? unidadMedida = freezed,Object? idCategoria = null,Object? diasSemana = null,}) {
  return _then(CreateHabitDto(
nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,fechaInicio: null == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,puntos: null == puntos ? _self.puntos : puntos // ignore: cast_nullable_to_non_nullable
as int,metaDiaria: freezed == metaDiaria ? _self.metaDiaria : metaDiaria // ignore: cast_nullable_to_non_nullable
as double?,unidadMedida: freezed == unidadMedida ? _self.unidadMedida : unidadMedida // ignore: cast_nullable_to_non_nullable
as String?,idCategoria: null == idCategoria ? _self.idCategoria : idCategoria // ignore: cast_nullable_to_non_nullable
as String,diasSemana: null == diasSemana ? _self.diasSemana : diasSemana // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateHabitDto].
extension CreateHabitDtoPatterns on CreateHabitDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateHabitDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateHabitDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateHabitDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateHabitDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateHabitDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateHabitDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nombre,  String? descripcion,  String fechaInicio,  String? fechaFin,  int puntos,  double? metaDiaria,  String? unidadMedida,  String idCategoria,  List<int> diasSemana)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateHabitDto() when $default != null:
return $default(_that.nombre,_that.descripcion,_that.fechaInicio,_that.fechaFin,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.diasSemana);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nombre,  String? descripcion,  String fechaInicio,  String? fechaFin,  int puntos,  double? metaDiaria,  String? unidadMedida,  String idCategoria,  List<int> diasSemana)  $default,) {final _that = this;
switch (_that) {
case _CreateHabitDto():
return $default(_that.nombre,_that.descripcion,_that.fechaInicio,_that.fechaFin,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.diasSemana);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nombre,  String? descripcion,  String fechaInicio,  String? fechaFin,  int puntos,  double? metaDiaria,  String? unidadMedida,  String idCategoria,  List<int> diasSemana)?  $default,) {final _that = this;
switch (_that) {
case _CreateHabitDto() when $default != null:
return $default(_that.nombre,_that.descripcion,_that.fechaInicio,_that.fechaFin,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.diasSemana);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateHabitDto implements CreateHabitDto {
  const _CreateHabitDto({required this.nombre, this.descripcion, required this.fechaInicio, this.fechaFin, required this.puntos, this.metaDiaria, this.unidadMedida, required this.idCategoria,  List<int> diasSemana = const [1, 2, 3, 4, 5, 6, 7]}): _diasSemana = diasSemana;
  factory _CreateHabitDto.fromJson(Map<String, dynamic> json) => _$CreateHabitDtoFromJson(json);

@override final  String nombre;
@override final  String? descripcion;
@override final  String fechaInicio;
@override final  String? fechaFin;
@override final  int puntos;
@override final  double? metaDiaria;
@override final  String? unidadMedida;
@override final  String idCategoria;
 final  List<int> _diasSemana;
@override@JsonKey() List<int> get diasSemana {
  if (_diasSemana is EqualUnmodifiableListView) return _diasSemana;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diasSemana);
}


/// Create a copy of CreateHabitDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateHabitDtoCopyWith<_CreateHabitDto> get copyWith => __$CreateHabitDtoCopyWithImpl<_CreateHabitDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateHabitDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateHabitDto&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&(identical(other.puntos, puntos) || other.puntos == puntos)&&(identical(other.metaDiaria, metaDiaria) || other.metaDiaria == metaDiaria)&&(identical(other.unidadMedida, unidadMedida) || other.unidadMedida == unidadMedida)&&(identical(other.idCategoria, idCategoria) || other.idCategoria == idCategoria)&&DeepCollectionEquality().equals(other._diasSemana, _diasSemana));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nombre,descripcion,fechaInicio,fechaFin,puntos,metaDiaria,unidadMedida,idCategoria,DeepCollectionEquality().hash(_diasSemana));

@override
String toString() {
  return 'CreateHabitDto(nombre: $nombre, descripcion: $descripcion, fechaInicio: $fechaInicio, fechaFin: $fechaFin, puntos: $puntos, metaDiaria: $metaDiaria, unidadMedida: $unidadMedida, idCategoria: $idCategoria, diasSemana: $diasSemana)';
}


}

/// @nodoc
abstract mixin class _$CreateHabitDtoCopyWith<$Res> implements $CreateHabitDtoCopyWith<$Res> {
  factory _$CreateHabitDtoCopyWith(_CreateHabitDto value, $Res Function(_CreateHabitDto) _then) = __$CreateHabitDtoCopyWithImpl;
@override @useResult
$Res call({
 String nombre, String? descripcion, String fechaInicio, String? fechaFin, int puntos, double? metaDiaria, String? unidadMedida, String idCategoria, List<int> diasSemana
});




}
/// @nodoc
class __$CreateHabitDtoCopyWithImpl<$Res>
    implements _$CreateHabitDtoCopyWith<$Res> {
  __$CreateHabitDtoCopyWithImpl(this._self, this._then);

  final _CreateHabitDto _self;
  final $Res Function(_CreateHabitDto) _then;

/// Create a copy of CreateHabitDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nombre = null,Object? descripcion = freezed,Object? fechaInicio = null,Object? fechaFin = freezed,Object? puntos = null,Object? metaDiaria = freezed,Object? unidadMedida = freezed,Object? idCategoria = null,Object? diasSemana = null,}) {
  return _then(_CreateHabitDto(
nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,fechaInicio: null == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,puntos: null == puntos ? _self.puntos : puntos // ignore: cast_nullable_to_non_nullable
as int,metaDiaria: freezed == metaDiaria ? _self.metaDiaria : metaDiaria // ignore: cast_nullable_to_non_nullable
as double?,unidadMedida: freezed == unidadMedida ? _self.unidadMedida : unidadMedida // ignore: cast_nullable_to_non_nullable
as String?,idCategoria: null == idCategoria ? _self.idCategoria : idCategoria // ignore: cast_nullable_to_non_nullable
as String,diasSemana: null == diasSemana ? _self._diasSemana : diasSemana // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
