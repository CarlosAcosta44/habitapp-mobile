// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitModel {

 String get id; String get nombre; String? get descripcion; int get puntos; double get metaDiaria; String get unidadMedida; String? get idCategoria; CategoryModel? get categoria; bool get completadoHoy; double get progresoHoy; int get rachaActual; String? get fechaInicio; String? get fechaFin; List<int> get diasSemana;
/// Create a copy of HabitModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitModelCopyWith<HabitModel> get copyWith => _$HabitModelCopyWithImpl<HabitModel>(this as HabitModel, _$identity);

  /// Serializes this HabitModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.puntos, puntos) || other.puntos == puntos)&&(identical(other.metaDiaria, metaDiaria) || other.metaDiaria == metaDiaria)&&(identical(other.unidadMedida, unidadMedida) || other.unidadMedida == unidadMedida)&&(identical(other.idCategoria, idCategoria) || other.idCategoria == idCategoria)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.completadoHoy, completadoHoy) || other.completadoHoy == completadoHoy)&&(identical(other.progresoHoy, progresoHoy) || other.progresoHoy == progresoHoy)&&(identical(other.rachaActual, rachaActual) || other.rachaActual == rachaActual)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&const DeepCollectionEquality().equals(other.diasSemana, diasSemana));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,descripcion,puntos,metaDiaria,unidadMedida,idCategoria,categoria,completadoHoy,progresoHoy,rachaActual,fechaInicio,fechaFin,const DeepCollectionEquality().hash(diasSemana));

@override
String toString() {
  return 'HabitModel(id: $id, nombre: $nombre, descripcion: $descripcion, puntos: $puntos, metaDiaria: $metaDiaria, unidadMedida: $unidadMedida, idCategoria: $idCategoria, categoria: $categoria, completadoHoy: $completadoHoy, progresoHoy: $progresoHoy, rachaActual: $rachaActual, fechaInicio: $fechaInicio, fechaFin: $fechaFin, diasSemana: $diasSemana)';
}


}

/// @nodoc
abstract mixin class $HabitModelCopyWith<$Res>  {
  factory $HabitModelCopyWith(HabitModel value, $Res Function(HabitModel) _then) = _$HabitModelCopyWithImpl;
@useResult
$Res call({
 String id, String nombre, String? descripcion, int puntos, double metaDiaria, String unidadMedida, String? idCategoria, CategoryModel? categoria, bool completadoHoy, double progresoHoy, int rachaActual, String? fechaInicio, String? fechaFin, List<int> diasSemana
});


$CategoryModelCopyWith<$Res>? get categoria;

}
/// @nodoc
class _$HabitModelCopyWithImpl<$Res>
    implements $HabitModelCopyWith<$Res> {
  _$HabitModelCopyWithImpl(this._self, this._then);

  final HabitModel _self;
  final $Res Function(HabitModel) _then;

/// Create a copy of HabitModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? descripcion = freezed,Object? puntos = null,Object? metaDiaria = null,Object? unidadMedida = null,Object? idCategoria = freezed,Object? categoria = freezed,Object? completadoHoy = null,Object? progresoHoy = null,Object? rachaActual = null,Object? fechaInicio = freezed,Object? fechaFin = freezed,Object? diasSemana = null,}) {
  return _then(HabitModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,puntos: null == puntos ? _self.puntos : puntos // ignore: cast_nullable_to_non_nullable
as int,metaDiaria: null == metaDiaria ? _self.metaDiaria : metaDiaria // ignore: cast_nullable_to_non_nullable
as double,unidadMedida: null == unidadMedida ? _self.unidadMedida : unidadMedida // ignore: cast_nullable_to_non_nullable
as String,idCategoria: freezed == idCategoria ? _self.idCategoria : idCategoria // ignore: cast_nullable_to_non_nullable
as String?,categoria: freezed == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as CategoryModel?,completadoHoy: null == completadoHoy ? _self.completadoHoy : completadoHoy // ignore: cast_nullable_to_non_nullable
as bool,progresoHoy: null == progresoHoy ? _self.progresoHoy : progresoHoy // ignore: cast_nullable_to_non_nullable
as double,rachaActual: null == rachaActual ? _self.rachaActual : rachaActual // ignore: cast_nullable_to_non_nullable
as int,fechaInicio: freezed == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String?,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,diasSemana: null == diasSemana ? _self.diasSemana : diasSemana // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of HabitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get categoria {
    if (_self.categoria == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.categoria!, (value) {
    return _then(_self.copyWith(categoria: value));
  });
}
}


/// Adds pattern-matching-related methods to [HabitModel].
extension HabitModelPatterns on HabitModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitModel value)  $default,){
final _that = this;
switch (_that) {
case _HabitModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitModel value)?  $default,){
final _that = this;
switch (_that) {
case _HabitModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombre,  String? descripcion,  int puntos,  double metaDiaria,  String unidadMedida,  String? idCategoria,  CategoryModel? categoria,  bool completadoHoy,  double progresoHoy,  int rachaActual,  String? fechaInicio,  String? fechaFin,  List<int> diasSemana)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitModel() when $default != null:
return $default(_that.id,_that.nombre,_that.descripcion,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.categoria,_that.completadoHoy,_that.progresoHoy,_that.rachaActual,_that.fechaInicio,_that.fechaFin,_that.diasSemana);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombre,  String? descripcion,  int puntos,  double metaDiaria,  String unidadMedida,  String? idCategoria,  CategoryModel? categoria,  bool completadoHoy,  double progresoHoy,  int rachaActual,  String? fechaInicio,  String? fechaFin,  List<int> diasSemana)  $default,) {final _that = this;
switch (_that) {
case _HabitModel():
return $default(_that.id,_that.nombre,_that.descripcion,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.categoria,_that.completadoHoy,_that.progresoHoy,_that.rachaActual,_that.fechaInicio,_that.fechaFin,_that.diasSemana);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombre,  String? descripcion,  int puntos,  double metaDiaria,  String unidadMedida,  String? idCategoria,  CategoryModel? categoria,  bool completadoHoy,  double progresoHoy,  int rachaActual,  String? fechaInicio,  String? fechaFin,  List<int> diasSemana)?  $default,) {final _that = this;
switch (_that) {
case _HabitModel() when $default != null:
return $default(_that.id,_that.nombre,_that.descripcion,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.categoria,_that.completadoHoy,_that.progresoHoy,_that.rachaActual,_that.fechaInicio,_that.fechaFin,_that.diasSemana);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitModel implements HabitModel {
  const _HabitModel({required this.id, required this.nombre, this.descripcion, this.puntos = 10, this.metaDiaria = 1.0, this.unidadMedida = 'veces', this.idCategoria, this.categoria, this.completadoHoy = false, this.progresoHoy = 0.0, this.rachaActual = 0, this.fechaInicio, this.fechaFin,  List<int> diasSemana = const [1, 2, 3, 4, 5, 6, 7]}): _diasSemana = diasSemana;
  factory _HabitModel.fromJson(Map<String, dynamic> json) => _$HabitModelFromJson(json);

@override final  String id;
@override final  String nombre;
@override final  String? descripcion;
@override@JsonKey() final  int puntos;
@override@JsonKey() final  double metaDiaria;
@override@JsonKey() final  String unidadMedida;
@override final  String? idCategoria;
@override final  CategoryModel? categoria;
@override@JsonKey() final  bool completadoHoy;
@override@JsonKey() final  double progresoHoy;
@override@JsonKey() final  int rachaActual;
@override final  String? fechaInicio;
@override final  String? fechaFin;
 final  List<int> _diasSemana;
@override@JsonKey() List<int> get diasSemana {
  if (_diasSemana is EqualUnmodifiableListView) return _diasSemana;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diasSemana);
}


/// Create a copy of HabitModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitModelCopyWith<_HabitModel> get copyWith => __$HabitModelCopyWithImpl<_HabitModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.puntos, puntos) || other.puntos == puntos)&&(identical(other.metaDiaria, metaDiaria) || other.metaDiaria == metaDiaria)&&(identical(other.unidadMedida, unidadMedida) || other.unidadMedida == unidadMedida)&&(identical(other.idCategoria, idCategoria) || other.idCategoria == idCategoria)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.completadoHoy, completadoHoy) || other.completadoHoy == completadoHoy)&&(identical(other.progresoHoy, progresoHoy) || other.progresoHoy == progresoHoy)&&(identical(other.rachaActual, rachaActual) || other.rachaActual == rachaActual)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&const DeepCollectionEquality().equals(other._diasSemana, _diasSemana));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,descripcion,puntos,metaDiaria,unidadMedida,idCategoria,categoria,completadoHoy,progresoHoy,rachaActual,fechaInicio,fechaFin,const DeepCollectionEquality().hash(_diasSemana));

@override
String toString() {
  return 'HabitModel(id: $id, nombre: $nombre, descripcion: $descripcion, puntos: $puntos, metaDiaria: $metaDiaria, unidadMedida: $unidadMedida, idCategoria: $idCategoria, categoria: $categoria, completadoHoy: $completadoHoy, progresoHoy: $progresoHoy, rachaActual: $rachaActual, fechaInicio: $fechaInicio, fechaFin: $fechaFin, diasSemana: $diasSemana)';
}


}

/// @nodoc
abstract mixin class _$HabitModelCopyWith<$Res> implements $HabitModelCopyWith<$Res> {
  factory _$HabitModelCopyWith(_HabitModel value, $Res Function(_HabitModel) _then) = __$HabitModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombre, String? descripcion, int puntos, double metaDiaria, String unidadMedida, String? idCategoria, CategoryModel? categoria, bool completadoHoy, double progresoHoy, int rachaActual, String? fechaInicio, String? fechaFin, List<int> diasSemana
});


@override $CategoryModelCopyWith<$Res>? get categoria;

}
/// @nodoc
class __$HabitModelCopyWithImpl<$Res>
    implements _$HabitModelCopyWith<$Res> {
  __$HabitModelCopyWithImpl(this._self, this._then);

  final _HabitModel _self;
  final $Res Function(_HabitModel) _then;

/// Create a copy of HabitModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? descripcion = freezed,Object? puntos = null,Object? metaDiaria = null,Object? unidadMedida = null,Object? idCategoria = freezed,Object? categoria = freezed,Object? completadoHoy = null,Object? progresoHoy = null,Object? rachaActual = null,Object? fechaInicio = freezed,Object? fechaFin = freezed,Object? diasSemana = null,}) {
  return _then(_HabitModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,puntos: null == puntos ? _self.puntos : puntos // ignore: cast_nullable_to_non_nullable
as int,metaDiaria: null == metaDiaria ? _self.metaDiaria : metaDiaria // ignore: cast_nullable_to_non_nullable
as double,unidadMedida: null == unidadMedida ? _self.unidadMedida : unidadMedida // ignore: cast_nullable_to_non_nullable
as String,idCategoria: freezed == idCategoria ? _self.idCategoria : idCategoria // ignore: cast_nullable_to_non_nullable
as String?,categoria: freezed == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as CategoryModel?,completadoHoy: null == completadoHoy ? _self.completadoHoy : completadoHoy // ignore: cast_nullable_to_non_nullable
as bool,progresoHoy: null == progresoHoy ? _self.progresoHoy : progresoHoy // ignore: cast_nullable_to_non_nullable
as double,rachaActual: null == rachaActual ? _self.rachaActual : rachaActual // ignore: cast_nullable_to_non_nullable
as int,fechaInicio: freezed == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String?,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,diasSemana: null == diasSemana ? _self._diasSemana : diasSemana // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of HabitModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get categoria {
    if (_self.categoria == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.categoria!, (value) {
    return _then(_self.copyWith(categoria: value));
  });
}
}

// dart format on
