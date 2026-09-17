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
    return ClientSummary(
      id: json['id'] as String,
      fullName: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
