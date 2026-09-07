class FriendModel {
  final String idusuario;
  final String nombre;
  final String apellido;
  final String? fotoperfil;
  final int rachaDias;
  final int puntosTotales;

  const FriendModel({
    required this.idusuario,
    required this.nombre,
    required this.apellido,
    this.fotoperfil,
    this.rachaDias = 0,
    this.puntosTotales = 0,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      idusuario: (json['id'] ?? json['idusuario']) as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      fotoperfil: json['fotoperfil'] as String?,
      rachaDias: json['rachaDias'] as int? ?? 0,
      puntosTotales: (json['puntos'] ?? json['puntosTotales'] ?? 0) as int,
    );
  }
}
