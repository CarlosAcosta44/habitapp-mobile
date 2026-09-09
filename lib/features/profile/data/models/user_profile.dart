import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String idusuario,
    required String nombre,
    required String apellido,
    required int puntostotales,
    required String idrol,
    @Default('Usuario') String nombrerol,
    @Default(0) int puntosFaltantesTop1,
    String? fotoperfil,
    String? correo,
    String? telefono,
    String? genero,
    String? fechanacimiento,
    String? zonaHoraria,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
