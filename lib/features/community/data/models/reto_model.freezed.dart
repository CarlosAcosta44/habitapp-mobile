// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reto_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RetoModel {

@JsonKey(name: 'id', readValue: _readId) String get id;@JsonKey(name: 'titulo', readValue: _readTitulo) String get titulo;@JsonKey(name: 'descripcion', readValue: _readDescripcion) String get descripcion;@JsonKey(name: 'puntosRecompensa', readValue: _readPuntos) int get puntosRecompensa; String? get fechaInicio; String? get fechaFin; String? get categoria;@JsonKey(name: 'isJoined', readValue: _readIsJoined) bool get isJoined;@JsonKey(name: 'participantCount', readValue: _readParticipantCount) int get participantCount;@JsonKey(name: 'currentProgress', readValue: _readCurrentProgress) int get currentProgress;@JsonKey(name: 'targetCount', readValue: _readTargetCount) int get targetCount; String? get icono;
/// Create a copy of RetoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RetoModelCopyWith<RetoModel> get copyWith => _$RetoModelCopyWithImpl<RetoModel>(this as RetoModel, _$identity);

  /// Serializes this RetoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.titulo, titulo) || other.titulo == titulo)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.puntosRecompensa, puntosRecompensa) || other.puntosRecompensa == puntosRecompensa)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.isJoined, isJoined) || other.isJoined == isJoined)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.currentProgress, currentProgress) || other.currentProgress == currentProgress)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.icono, icono) || other.icono == icono));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titulo,descripcion,puntosRecompensa,fechaInicio,fechaFin,categoria,isJoined,participantCount,currentProgress,targetCount,icono);

@override
String toString() {
  return 'RetoModel(id: $id, titulo: $titulo, descripcion: $descripcion, puntosRecompensa: $puntosRecompensa, fechaInicio: $fechaInicio, fechaFin: $fechaFin, categoria: $categoria, isJoined: $isJoined, participantCount: $participantCount, currentProgress: $currentProgress, targetCount: $targetCount, icono: $icono)';
}


}

/// @nodoc
abstract mixin class $RetoModelCopyWith<$Res>  {
  factory $RetoModelCopyWith(RetoModel value, $Res Function(RetoModel) _then) = _$RetoModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'titulo', readValue: _readTitulo) String titulo,@JsonKey(name: 'descripcion', readValue: _readDescripcion) String descripcion,@JsonKey(name: 'puntosRecompensa', readValue: _readPuntos) int puntosRecompensa, String? fechaInicio, String? fechaFin, String? categoria,@JsonKey(name: 'isJoined', readValue: _readIsJoined) bool isJoined,@JsonKey(name: 'participantCount', readValue: _readParticipantCount) int participantCount,@JsonKey(name: 'currentProgress', readValue: _readCurrentProgress) int currentProgress,@JsonKey(name: 'targetCount', readValue: _readTargetCount) int targetCount, String? icono
});




}
/// @nodoc
class _$RetoModelCopyWithImpl<$Res>
    implements $RetoModelCopyWith<$Res> {
  _$RetoModelCopyWithImpl(this._self, this._then);

  final RetoModel _self;
  final $Res Function(RetoModel) _then;

/// Create a copy of RetoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titulo = null,Object? descripcion = null,Object? puntosRecompensa = null,Object? fechaInicio = freezed,Object? fechaFin = freezed,Object? categoria = freezed,Object? isJoined = null,Object? participantCount = null,Object? currentProgress = null,Object? targetCount = null,Object? icono = freezed,}) {
  return _then(RetoModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titulo: null == titulo ? _self.titulo : titulo // ignore: cast_nullable_to_non_nullable
as String,descripcion: null == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String,puntosRecompensa: null == puntosRecompensa ? _self.puntosRecompensa : puntosRecompensa // ignore: cast_nullable_to_non_nullable
as int,fechaInicio: freezed == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String?,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,categoria: freezed == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as String?,isJoined: null == isJoined ? _self.isJoined : isJoined // ignore: cast_nullable_to_non_nullable
as bool,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,currentProgress: null == currentProgress ? _self.currentProgress : currentProgress // ignore: cast_nullable_to_non_nullable
as int,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,icono: freezed == icono ? _self.icono : icono // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RetoModel].
extension RetoModelPatterns on RetoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RetoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RetoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RetoModel value)  $default,){
final _that = this;
switch (_that) {
case _RetoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RetoModel value)?  $default,){
final _that = this;
switch (_that) {
case _RetoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'titulo', readValue: _readTitulo)  String titulo, @JsonKey(name: 'descripcion', readValue: _readDescripcion)  String descripcion, @JsonKey(name: 'puntosRecompensa', readValue: _readPuntos)  int puntosRecompensa,  String? fechaInicio,  String? fechaFin,  String? categoria, @JsonKey(name: 'isJoined', readValue: _readIsJoined)  bool isJoined, @JsonKey(name: 'participantCount', readValue: _readParticipantCount)  int participantCount, @JsonKey(name: 'currentProgress', readValue: _readCurrentProgress)  int currentProgress, @JsonKey(name: 'targetCount', readValue: _readTargetCount)  int targetCount,  String? icono)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RetoModel() when $default != null:
return $default(_that.id,_that.titulo,_that.descripcion,_that.puntosRecompensa,_that.fechaInicio,_that.fechaFin,_that.categoria,_that.isJoined,_that.participantCount,_that.currentProgress,_that.targetCount,_that.icono);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'titulo', readValue: _readTitulo)  String titulo, @JsonKey(name: 'descripcion', readValue: _readDescripcion)  String descripcion, @JsonKey(name: 'puntosRecompensa', readValue: _readPuntos)  int puntosRecompensa,  String? fechaInicio,  String? fechaFin,  String? categoria, @JsonKey(name: 'isJoined', readValue: _readIsJoined)  bool isJoined, @JsonKey(name: 'participantCount', readValue: _readParticipantCount)  int participantCount, @JsonKey(name: 'currentProgress', readValue: _readCurrentProgress)  int currentProgress, @JsonKey(name: 'targetCount', readValue: _readTargetCount)  int targetCount,  String? icono)  $default,) {final _that = this;
switch (_that) {
case _RetoModel():
return $default(_that.id,_that.titulo,_that.descripcion,_that.puntosRecompensa,_that.fechaInicio,_that.fechaFin,_that.categoria,_that.isJoined,_that.participantCount,_that.currentProgress,_that.targetCount,_that.icono);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', readValue: _readId)  String id, @JsonKey(name: 'titulo', readValue: _readTitulo)  String titulo, @JsonKey(name: 'descripcion', readValue: _readDescripcion)  String descripcion, @JsonKey(name: 'puntosRecompensa', readValue: _readPuntos)  int puntosRecompensa,  String? fechaInicio,  String? fechaFin,  String? categoria, @JsonKey(name: 'isJoined', readValue: _readIsJoined)  bool isJoined, @JsonKey(name: 'participantCount', readValue: _readParticipantCount)  int participantCount, @JsonKey(name: 'currentProgress', readValue: _readCurrentProgress)  int currentProgress, @JsonKey(name: 'targetCount', readValue: _readTargetCount)  int targetCount,  String? icono)?  $default,) {final _that = this;
switch (_that) {
case _RetoModel() when $default != null:
return $default(_that.id,_that.titulo,_that.descripcion,_that.puntosRecompensa,_that.fechaInicio,_that.fechaFin,_that.categoria,_that.isJoined,_that.participantCount,_that.currentProgress,_that.targetCount,_that.icono);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RetoModel extends RetoModel {
  const _RetoModel({@JsonKey(name: 'id', readValue: _readId) required this.id, @JsonKey(name: 'titulo', readValue: _readTitulo) required this.titulo, @JsonKey(name: 'descripcion', readValue: _readDescripcion) this.descripcion = '', @JsonKey(name: 'puntosRecompensa', readValue: _readPuntos) this.puntosRecompensa = 100, this.fechaInicio, this.fechaFin, this.categoria, @JsonKey(name: 'isJoined', readValue: _readIsJoined) this.isJoined = false, @JsonKey(name: 'participantCount', readValue: _readParticipantCount) this.participantCount = 1, @JsonKey(name: 'currentProgress', readValue: _readCurrentProgress) this.currentProgress = 0, @JsonKey(name: 'targetCount', readValue: _readTargetCount) this.targetCount = 7, this.icono}): super._();
  factory _RetoModel.fromJson(Map<String, dynamic> json) => _$RetoModelFromJson(json);

@override@JsonKey(name: 'id', readValue: _readId) final  String id;
@override@JsonKey(name: 'titulo', readValue: _readTitulo) final  String titulo;
@override@JsonKey(name: 'descripcion', readValue: _readDescripcion) final  String descripcion;
@override@JsonKey(name: 'puntosRecompensa', readValue: _readPuntos) final  int puntosRecompensa;
@override final  String? fechaInicio;
@override final  String? fechaFin;
@override final  String? categoria;
@override@JsonKey(name: 'isJoined', readValue: _readIsJoined) final  bool isJoined;
@override@JsonKey(name: 'participantCount', readValue: _readParticipantCount) final  int participantCount;
@override@JsonKey(name: 'currentProgress', readValue: _readCurrentProgress) final  int currentProgress;
@override@JsonKey(name: 'targetCount', readValue: _readTargetCount) final  int targetCount;
@override final  String? icono;

/// Create a copy of RetoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RetoModelCopyWith<_RetoModel> get copyWith => __$RetoModelCopyWithImpl<_RetoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RetoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.titulo, titulo) || other.titulo == titulo)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.puntosRecompensa, puntosRecompensa) || other.puntosRecompensa == puntosRecompensa)&&(identical(other.fechaInicio, fechaInicio) || other.fechaInicio == fechaInicio)&&(identical(other.fechaFin, fechaFin) || other.fechaFin == fechaFin)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.isJoined, isJoined) || other.isJoined == isJoined)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&(identical(other.currentProgress, currentProgress) || other.currentProgress == currentProgress)&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.icono, icono) || other.icono == icono));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titulo,descripcion,puntosRecompensa,fechaInicio,fechaFin,categoria,isJoined,participantCount,currentProgress,targetCount,icono);

@override
String toString() {
  return 'RetoModel(id: $id, titulo: $titulo, descripcion: $descripcion, puntosRecompensa: $puntosRecompensa, fechaInicio: $fechaInicio, fechaFin: $fechaFin, categoria: $categoria, isJoined: $isJoined, participantCount: $participantCount, currentProgress: $currentProgress, targetCount: $targetCount, icono: $icono)';
}


}

/// @nodoc
abstract mixin class _$RetoModelCopyWith<$Res> implements $RetoModelCopyWith<$Res> {
  factory _$RetoModelCopyWith(_RetoModel value, $Res Function(_RetoModel) _then) = __$RetoModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', readValue: _readId) String id,@JsonKey(name: 'titulo', readValue: _readTitulo) String titulo,@JsonKey(name: 'descripcion', readValue: _readDescripcion) String descripcion,@JsonKey(name: 'puntosRecompensa', readValue: _readPuntos) int puntosRecompensa, String? fechaInicio, String? fechaFin, String? categoria,@JsonKey(name: 'isJoined', readValue: _readIsJoined) bool isJoined,@JsonKey(name: 'participantCount', readValue: _readParticipantCount) int participantCount,@JsonKey(name: 'currentProgress', readValue: _readCurrentProgress) int currentProgress,@JsonKey(name: 'targetCount', readValue: _readTargetCount) int targetCount, String? icono
});




}
/// @nodoc
class __$RetoModelCopyWithImpl<$Res>
    implements _$RetoModelCopyWith<$Res> {
  __$RetoModelCopyWithImpl(this._self, this._then);

  final _RetoModel _self;
  final $Res Function(_RetoModel) _then;

/// Create a copy of RetoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titulo = null,Object? descripcion = null,Object? puntosRecompensa = null,Object? fechaInicio = freezed,Object? fechaFin = freezed,Object? categoria = freezed,Object? isJoined = null,Object? participantCount = null,Object? currentProgress = null,Object? targetCount = null,Object? icono = freezed,}) {
  return _then(_RetoModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titulo: null == titulo ? _self.titulo : titulo // ignore: cast_nullable_to_non_nullable
as String,descripcion: null == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String,puntosRecompensa: null == puntosRecompensa ? _self.puntosRecompensa : puntosRecompensa // ignore: cast_nullable_to_non_nullable
as int,fechaInicio: freezed == fechaInicio ? _self.fechaInicio : fechaInicio // ignore: cast_nullable_to_non_nullable
as String?,fechaFin: freezed == fechaFin ? _self.fechaFin : fechaFin // ignore: cast_nullable_to_non_nullable
as String?,categoria: freezed == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as String?,isJoined: null == isJoined ? _self.isJoined : isJoined // ignore: cast_nullable_to_non_nullable
as bool,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,currentProgress: null == currentProgress ? _self.currentProgress : currentProgress // ignore: cast_nullable_to_non_nullable
as int,targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,icono: freezed == icono ? _self.icono : icono // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
