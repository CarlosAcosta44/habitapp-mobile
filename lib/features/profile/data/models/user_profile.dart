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
    required String nombrerol,
    String? fotoperfil,
    String? telefono,
    String? genero,
    String? fechanacimiento,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
