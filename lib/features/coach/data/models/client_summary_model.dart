class ClientSummary {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;

  ClientSummary({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  factory ClientSummary.fromJson(Map<String, dynamic> json) {
    final clientData = json['client'] is Map<String, dynamic>
        ? json['client'] as Map<String, dynamic>
        : json;
    final composedName =
        '${clientData['nombre'] ?? ''} ${clientData['apellido'] ?? ''}'.trim();
    return ClientSummary(
      id: (clientData['id'] ?? clientData['idusuario'] ?? '').toString(),
      fullName: (clientData['fullName'] ??
              clientData['full_name'] ??
              clientData['name'] ??
              composedName)
          .toString(),
      email: (clientData['email'] ?? clientData['correo'] ?? '').toString(),
      avatarUrl: (clientData['avatarUrl'] ??
          clientData['avatar_url'] ??
          clientData['fotoperfil']) as String?,
    );
  }
}
