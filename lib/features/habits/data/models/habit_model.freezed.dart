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

@JsonKey(name: 'idHabito') String get id; String get nombre; String? get descripcion; int get puntos; double get metaDiaria; String get unidadMedida; String? get idCategoria; CategoryModel? get categoria; bool get completadoHoy; double get progresoHoy; int get rachaActual; int get mejorRacha; int get tasaExito; int get totalCumplido; List<HabitRecordModel> get historialReciente; String? get fechaInicio; String? get fechaFin; List<int> get diasSemana; List<String> get fechasCompletadas; String? get estado;
/// Create a copy of HabitModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitModelCopyWith<HabitModel> get copyWith => _$HabitModelCopyWithImpl<HabitModel>(this as HabitModel, _$identity);

  /// Serializes this HabitModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.puntos, puntos) || other.puntos == puntos)&&(identical(other.metaDiaria, metaDiaria) || other.metaDiaria == metaDiaria)&&(identical(other.unidadMedida, unidadMedida) || other.unidadMedida == unidadMedida)&&(identical(other.idCategoria, idCategoria) || other.idCategoria == idCategoria)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.completadoHoy, completadoHoy) || other.completadoHoy == completadoHoy)&&(identical(other.progresoHoy, progresoHoy) || other.progresoHoy == progresoHoy)&&(identical(other.rachaActual, rachaActual) || other.rachaActual == rachaActual)&&(identical(other.mejorRacha, mejorRacha) || other.mejorRacha == mejorRacha)&&(identical(other.tasaExito, tasaExito) || other.tasaExito == tasaExito)&&(identical(other.totalCumplido, totalCumplido) || other.totalCumplido == totalCumplido)&&const DeepCollectionEquality().equals(other.historialReciente, historialReciente)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&const DeepCollectionEquality().equals(other.diasSemana, diasSemana)&&const DeepCollectionEquality().equals(other.fechasCompletadas, fechasCompletadas)&&(identical(other.estado, estado) || other.estado == estado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,nombre,descripcion,puntos,metaDiaria,unidadMedida,idCategoria,categoria,completadoHoy,progresoHoy,rachaActual,mejorRacha,tasaExito,totalCumplido,const DeepCollectionEquality().hash(historialReciente),fechaInicio,fechaFin,const DeepCollectionEquality().hash(diasSemana),const DeepCollectionEquality().hash(fechasCompletadas),estado]);

@override
String toString() {
  return 'HabitModel(id: $id, nombre: $nombre, descripcion: $descripcion, puntos: $puntos, metaDiaria: $metaDiaria, unidadMedida: $unidadMedida, idCategoria: $idCategoria, categoria: $categoria, completadoHoy: $completadoHoy, progresoHoy: $progresoHoy, rachaActual: $rachaActual, mejorRacha: $mejorRacha, tasaExito: $tasaExito, totalCumplido: $totalCumplido, historialReciente: $historialReciente, fechaInicio: $fechaInicio, fechaFin: $fechaFin, diasSemana: $diasSemana, fechasCompletadas: $fechasCompletadas, estado: $estado)';
}


}

/// @nodoc
abstract mixin class $HabitModelCopyWith<$Res>  {
  factory $HabitModelCopyWith(HabitModel value, $Res Function(HabitModel) _then) = _$HabitModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'idHabito') String id, String nombre, String? descripcion, int puntos, double metaDiaria, String unidadMedida, String? idCategoria, CategoryModel? categoria, bool completadoHoy, double progresoHoy, int rachaActual, int mejorRacha, int tasaExito, int totalCumplido, List<HabitRecordModel> historialReciente, String? fechaInicio, String? fechaFin, List<int> diasSemana, List<String> fechasCompletadas, String? estado
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? descripcion = freezed,Object? puntos = null,Object? metaDiaria = null,Object? unidadMedida = null,Object? idCategoria = freezed,Object? categoria = freezed,Object? completadoHoy = null,Object? progresoHoy = null,Object? rachaActual = null,Object? mejorRacha = null,Object? tasaExito = null,Object? totalCumplido = null,Object? historialReciente = null,Object? fechaInicio = freezed,Object? fechaFin = freezed,Object? diasSemana = null,Object? fechasCompletadas = null,Object? estado = freezed,}) {
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
as int,mejorRacha: null == mejorRacha ? _self.mejorRacha : mejorRacha // ignore: cast_nullable_to_non_nullable
as int,tasaExito: null == tasaExito ? _self.tasaExito : tasaExito // ignore: cast_nullable_to_non_nullable
as int,totalCumplido: null == totalCumplido ? _self.totalCumplido : totalCumplido // ignore: cast_nullable_to_non_nullable
as int,historialReciente: null == historialReciente ? _self.historialReciente : historialReciente // ignore: cast_nullable_to_non_nullable
as List<HabitRecordModel>,fechaInicio: freezed == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String?,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,diasSemana: null == diasSemana ? _self.diasSemana : diasSemana // ignore: cast_nullable_to_non_nullable
as List<int>,fechasCompletadas: null == fechasCompletadas ? _self.fechasCompletadas : fechasCompletadas // ignore: cast_nullable_to_non_nullable
as List<String>,estado: freezed == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'idHabito')  String id,  String nombre,  String? descripcion,  int puntos,  double metaDiaria,  String unidadMedida,  String? idCategoria,  CategoryModel? categoria,  bool completadoHoy,  double progresoHoy,  int rachaActual,  int mejorRacha,  int tasaExito,  int totalCumplido,  List<HabitRecordModel> historialReciente,  String? fechaInicio,  String? fechaFin,  List<int> diasSemana,  List<String> fechasCompletadas,  String? estado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitModel() when $default != null:
return $default(_that.id,_that.nombre,_that.descripcion,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.categoria,_that.completadoHoy,_that.progresoHoy,_that.rachaActual,_that.mejorRacha,_that.tasaExito,_that.totalCumplido,_that.historialReciente,_that.fechaInicio,_that.fechaFin,_that.diasSemana,_that.fechasCompletadas,_that.estado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'idHabito')  String id,  String nombre,  String? descripcion,  int puntos,  double metaDiaria,  String unidadMedida,  String? idCategoria,  CategoryModel? categoria,  bool completadoHoy,  double progresoHoy,  int rachaActual,  int mejorRacha,  int tasaExito,  int totalCumplido,  List<HabitRecordModel> historialReciente,  String? fechaInicio,  String? fechaFin,  List<int> diasSemana,  List<String> fechasCompletadas,  String? estado)  $default,) {final _that = this;
switch (_that) {
case _HabitModel():
return $default(_that.id,_that.nombre,_that.descripcion,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.categoria,_that.completadoHoy,_that.progresoHoy,_that.rachaActual,_that.mejorRacha,_that.tasaExito,_that.totalCumplido,_that.historialReciente,_that.fechaInicio,_that.fechaFin,_that.diasSemana,_that.fechasCompletadas,_that.estado);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'idHabito')  String id,  String nombre,  String? descripcion,  int puntos,  double metaDiaria,  String unidadMedida,  String? idCategoria,  CategoryModel? categoria,  bool completadoHoy,  double progresoHoy,  int rachaActual,  int mejorRacha,  int tasaExito,  int totalCumplido,  List<HabitRecordModel> historialReciente,  String? fechaInicio,  String? fechaFin,  List<int> diasSemana,  List<String> fechasCompletadas,  String? estado)?  $default,) {final _that = this;
switch (_that) {
case _HabitModel() when $default != null:
return $default(_that.id,_that.nombre,_that.descripcion,_that.puntos,_that.metaDiaria,_that.unidadMedida,_that.idCategoria,_that.categoria,_that.completadoHoy,_that.progresoHoy,_that.rachaActual,_that.mejorRacha,_that.tasaExito,_that.totalCumplido,_that.historialReciente,_that.fechaInicio,_that.fechaFin,_that.diasSemana,_that.fechasCompletadas,_that.estado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitModel implements HabitModel {
  const _HabitModel({@JsonKey(name: 'idHabito') required this.id, required this.nombre, this.descripcion, this.puntos = 10, this.metaDiaria = 1.0, this.unidadMedida = 'veces', this.idCategoria, this.categoria, this.completadoHoy = false, this.progresoHoy = 0.0, this.rachaActual = 0, this.mejorRacha = 0, this.tasaExito = 0, this.totalCumplido = 0,  List<HabitRecordModel> historialReciente = const [], this.fechaInicio, this.fechaFin,  List<int> diasSemana = const [1, 2, 3, 4, 5, 6, 7],  List<String> fechasCompletadas = const [], this.estado}): _historialReciente = historialReciente,_diasSemana = diasSemana,_fechasCompletadas = fechasCompletadas;
  factory _HabitModel.fromJson(Map<String, dynamic> json) => _$HabitModelFromJson(json);

@override@JsonKey(name: 'idHabito') final  String id;
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
@override@JsonKey() final  int mejorRacha;
@override@JsonKey() final  int tasaExito;
@override@JsonKey() final  int totalCumplido;
 final  List<HabitRecordModel> _historialReciente;
@override@JsonKey() List<HabitRecordModel> get historialReciente {
  if (_historialReciente is EqualUnmodifiableListView) return _historialReciente;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_historialReciente);
}

@override final  String? fechaInicio;
@override final  String? fechaFin;
 final  List<int> _diasSemana;
@override@JsonKey() List<int> get diasSemana {
  if (_diasSemana is EqualUnmodifiableListView) return _diasSemana;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diasSemana);
}

 final  List<String> _fechasCompletadas;
@override@JsonKey() List<String> get fechasCompletadas {
  if (_fechasCompletadas is EqualUnmodifiableListView) return _fechasCompletadas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fechasCompletadas);
}

@override final  String? estado;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.puntos, puntos) || other.puntos == puntos)&&(identical(other.metaDiaria, metaDiaria) || other.metaDiaria == metaDiaria)&&(identical(other.unidadMedida, unidadMedida) || other.unidadMedida == unidadMedida)&&(identical(other.idCategoria, idCategoria) || other.idCategoria == idCategoria)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.completadoHoy, completadoHoy) || other.completadoHoy == completadoHoy)&&(identical(other.progresoHoy, progresoHoy) || other.progresoHoy == progresoHoy)&&(identical(other.rachaActual, rachaActual) || other.rachaActual == rachaActual)&&(identical(other.mejorRacha, mejorRacha) || other.mejorRacha == mejorRacha)&&(identical(other.tasaExito, tasaExito) || other.tasaExito == tasaExito)&&(identical(other.totalCumplido, totalCumplido) || other.totalCumplido == totalCumplido)&&const DeepCollectionEquality().equals(other._historialReciente, _historialReciente)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&const DeepCollectionEquality().equals(other._diasSemana, _diasSemana)&&const DeepCollectionEquality().equals(other._fechasCompletadas, _fechasCompletadas)&&(identical(other.estado, estado) || other.estado == estado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,nombre,descripcion,puntos,metaDiaria,unidadMedida,idCategoria,categoria,completadoHoy,progresoHoy,rachaActual,mejorRacha,tasaExito,totalCumplido,const DeepCollectionEquality().hash(_historialReciente),fechaInicio,fechaFin,const DeepCollectionEquality().hash(_diasSemana),const DeepCollectionEquality().hash(_fechasCompletadas),estado]);

@override
String toString() {
  return 'HabitModel(id: $id, nombre: $nombre, descripcion: $descripcion, puntos: $puntos, metaDiaria: $metaDiaria, unidadMedida: $unidadMedida, idCategoria: $idCategoria, categoria: $categoria, completadoHoy: $completadoHoy, progresoHoy: $progresoHoy, rachaActual: $rachaActual, mejorRacha: $mejorRacha, tasaExito: $tasaExito, totalCumplido: $totalCumplido, historialReciente: $historialReciente, fechaInicio: $fechaInicio, fechaFin: $fechaFin, diasSemana: $diasSemana, fechasCompletadas: $fechasCompletadas, estado: $estado)';
}


}

/// @nodoc
abstract mixin class _$HabitModelCopyWith<$Res> implements $HabitModelCopyWith<$Res> {
  factory _$HabitModelCopyWith(_HabitModel value, $Res Function(_HabitModel) _then) = __$HabitModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'idHabito') String id, String nombre, String? descripcion, int puntos, double metaDiaria, String unidadMedida, String? idCategoria, CategoryModel? categoria, bool completadoHoy, double progresoHoy, int rachaActual, int mejorRacha, int tasaExito, int totalCumplido, List<HabitRecordModel> historialReciente, String? fechaInicio, String? fechaFin, List<int> diasSemana, List<String> fechasCompletadas, String? estado
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? descripcion = freezed,Object? puntos = null,Object? metaDiaria = null,Object? unidadMedida = null,Object? idCategoria = freezed,Object? categoria = freezed,Object? completadoHoy = null,Object? progresoHoy = null,Object? rachaActual = null,Object? mejorRacha = null,Object? tasaExito = null,Object? totalCumplido = null,Object? historialReciente = null,Object? fechaInicio = freezed,Object? fechaFin = freezed,Object? diasSemana = null,Object? fechasCompletadas = null,Object? estado = freezed,}) {
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
as int,mejorRacha: null == mejorRacha ? _self.mejorRacha : mejorRacha // ignore: cast_nullable_to_non_nullable
as int,tasaExito: null == tasaExito ? _self.tasaExito : tasaExito // ignore: cast_nullable_to_non_nullable
as int,totalCumplido: null == totalCumplido ? _self.totalCumplido : totalCumplido // ignore: cast_nullable_to_non_nullable
as int,historialReciente: null == historialReciente ? _self._historialReciente : historialReciente // ignore: cast_nullable_to_non_nullable
as List<HabitRecordModel>,fechaInicio: freezed == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String?,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,diasSemana: null == diasSemana ? _self._diasSemana : diasSemana // ignore: cast_nullable_to_non_nullable
as List<int>,fechasCompletadas: null == fechasCompletadas ? _self._fechasCompletadas : fechasCompletadas // ignore: cast_nullable_to_non_nullable
as List<String>,estado: freezed == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as String?,
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
