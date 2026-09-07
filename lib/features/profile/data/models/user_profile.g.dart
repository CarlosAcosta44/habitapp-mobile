// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  idusuario: json['idusuario'] as String,
  nombre: json['nombre'] as String,
  apellido: json['apellido'] as String,
  puntostotales: (json['puntostotales'] as num).toInt(),
  idrol: json['idrol'] as String,
  nombrerol: json['nombrerol'] as String? ?? 'Usuario',
  puntosFaltantesTop1: (json['puntosFaltantesTop1'] as num?)?.toInt() ?? 0,
  fotoperfil: json['fotoperfil'] as String?,
  correo: json['correo'] as String?,
  telefono: json['telefono'] as String?,
  genero: json['genero'] as String?,
  fechanacimiento: json['fechanacimiento'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'idusuario': instance.idusuario,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'puntostotales': instance.puntostotales,
      'idrol': instance.idrol,
      'nombrerol': instance.nombrerol,
      'puntosFaltantesTop1': instance.puntosFaltantesTop1,
      'fotoperfil': instance.fotoperfil,
      'correo': instance.correo,
      'telefono': instance.telefono,
      'genero': instance.genero,
      'fechanacimiento': instance.fechanacimiento,
    };
