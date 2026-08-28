// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get idusuario; String get nombre; String get apellido; int get puntostotales; String get idrol; String get nombrerol; String? get fotoperfil; String? get telefono; String? get genero; String? get fechanacimiento;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.idusuario, idusuario) || other.idusuario == idusuario)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.apellido, apellido) || other.apellido == apellido)&&(identical(other.puntostotales, puntostotales) || other.puntostotales == puntostotales)&&(identical(other.idrol, idrol) || other.idrol == idrol)&&(identical(other.nombrerol, nombrerol) || other.nombrerol == nombrerol)&&(identical(other.fotoperfil, fotoperfil) || other.fotoperfil == fotoperfil)&&(identical(other.telefono, telefono) || other.telefono == telefono)&&(identical(other.genero, genero) || other.genero == genero)&&(identical(other.fechanacimiento, fechanacimiento) || other.fechanacimiento == fechanacimiento));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idusuario,nombre,apellido,puntostotales,idrol,nombrerol,fotoperfil,telefono,genero,fechanacimiento);

@override
String toString() {
  return 'UserProfile(idusuario: $idusuario, nombre: $nombre, apellido: $apellido, puntostotales: $puntostotales, idrol: $idrol, nombrerol: $nombrerol, fotoperfil: $fotoperfil, telefono: $telefono, genero: $genero, fechanacimiento: $fechanacimiento)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String idusuario, String nombre, String apellido, int puntostotales, String idrol, String nombrerol, String? fotoperfil, String? telefono, String? genero, String? fechanacimiento
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idusuario = null,Object? nombre = null,Object? apellido = null,Object? puntostotales = null,Object? idrol = null,Object? nombrerol = null,Object? fotoperfil = freezed,Object? telefono = freezed,Object? genero = freezed,Object? fechanacimiento = freezed,}) {
  return _then(UserProfile(
idusuario: null == idusuario ? _self.idusuario : idusuario // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,apellido: null == apellido ? _self.apellido : apellido // ignore: cast_nullable_to_non_nullable
as String,puntostotales: null == puntostotales ? _self.puntostotales : puntostotales // ignore: cast_nullable_to_non_nullable
as int,idrol: null == idrol ? _self.idrol : idrol // ignore: cast_nullable_to_non_nullable
as String,nombrerol: null == nombrerol ? _self.nombrerol : nombrerol // ignore: cast_nullable_to_non_nullable
as String,fotoperfil: freezed == fotoperfil ? _self.fotoperfil : fotoperfil // ignore: cast_nullable_to_non_nullable
as String?,telefono: freezed == telefono ? _self.telefono : telefono // ignore: cast_nullable_to_non_nullable
as String?,genero: freezed == genero ? _self.genero : genero // ignore: cast_nullable_to_non_nullable
as String?,fechanacimiento: freezed == fechanacimiento ? _self.fechanacimiento : fechanacimiento // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String idusuario,  String nombre,  String apellido,  int puntostotales,  String idrol,  String nombrerol,  String? fotoperfil,  String? telefono,  String? genero,  String? fechanacimiento)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.idusuario,_that.nombre,_that.apellido,_that.puntostotales,_that.idrol,_that.nombrerol,_that.fotoperfil,_that.telefono,_that.genero,_that.fechanacimiento);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String idusuario,  String nombre,  String apellido,  int puntostotales,  String idrol,  String nombrerol,  String? fotoperfil,  String? telefono,  String? genero,  String? fechanacimiento)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.idusuario,_that.nombre,_that.apellido,_that.puntostotales,_that.idrol,_that.nombrerol,_that.fotoperfil,_that.telefono,_that.genero,_that.fechanacimiento);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String idusuario,  String nombre,  String apellido,  int puntostotales,  String idrol,  String nombrerol,  String? fotoperfil,  String? telefono,  String? genero,  String? fechanacimiento)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.idusuario,_that.nombre,_that.apellido,_that.puntostotales,_that.idrol,_that.nombrerol,_that.fotoperfil,_that.telefono,_that.genero,_that.fechanacimiento);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.idusuario, required this.nombre, required this.apellido, required this.puntostotales, required this.idrol, required this.nombrerol, this.fotoperfil, this.telefono, this.genero, this.fechanacimiento});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String idusuario;
@override final  String nombre;
@override final  String apellido;
@override final  int puntostotales;
@override final  String idrol;
@override final  String nombrerol;
@override final  String? fotoperfil;
@override final  String? telefono;
@override final  String? genero;
@override final  String? fechanacimiento;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.idusuario, idusuario) || other.idusuario == idusuario)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.apellido, apellido) || other.apellido == apellido)&&(identical(other.puntostotales, puntostotales) || other.puntostotales == puntostotales)&&(identical(other.idrol, idrol) || other.idrol == idrol)&&(identical(other.nombrerol, nombrerol) || other.nombrerol == nombrerol)&&(identical(other.fotoperfil, fotoperfil) || other.fotoperfil == fotoperfil)&&(identical(other.telefono, telefono) || other.telefono == telefono)&&(identical(other.genero, genero) || other.genero == genero)&&(identical(other.fechanacimiento, fechanacimiento) || other.fechanacimiento == fechanacimiento));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idusuario,nombre,apellido,puntostotales,idrol,nombrerol,fotoperfil,telefono,genero,fechanacimiento);

@override
String toString() {
  return 'UserProfile(idusuario: $idusuario, nombre: $nombre, apellido: $apellido, puntostotales: $puntostotales, idrol: $idrol, nombrerol: $nombrerol, fotoperfil: $fotoperfil, telefono: $telefono, genero: $genero, fechanacimiento: $fechanacimiento)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String idusuario, String nombre, String apellido, int puntostotales, String idrol, String nombrerol, String? fotoperfil, String? telefono, String? genero, String? fechanacimiento
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idusuario = null,Object? nombre = null,Object? apellido = null,Object? puntostotales = null,Object? idrol = null,Object? nombrerol = null,Object? fotoperfil = freezed,Object? telefono = freezed,Object? genero = freezed,Object? fechanacimiento = freezed,}) {
  return _then(_UserProfile(
idusuario: null == idusuario ? _self.idusuario : idusuario // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,apellido: null == apellido ? _self.apellido : apellido // ignore: cast_nullable_to_non_nullable
as String,puntostotales: null == puntostotales ? _self.puntostotales : puntostotales // ignore: cast_nullable_to_non_nullable
as int,idrol: null == idrol ? _self.idrol : idrol // ignore: cast_nullable_to_non_nullable
as String,nombrerol: null == nombrerol ? _self.nombrerol : nombrerol // ignore: cast_nullable_to_non_nullable
as String,fotoperfil: freezed == fotoperfil ? _self.fotoperfil : fotoperfil // ignore: cast_nullable_to_non_nullable
as String?,telefono: freezed == telefono ? _self.telefono : telefono // ignore: cast_nullable_to_non_nullable
as String?,genero: freezed == genero ? _self.genero : genero // ignore: cast_nullable_to_non_nullable
as String?,fechanacimiento: freezed == fechanacimiento ? _self.fechanacimiento : fechanacimiento // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
