class UserStats {
  final int activeHabitsCount;
  final int tasaExito;
  final int diasTotales;
  final int rachaActual;

  UserStats({
    required this.activeHabitsCount,
    required this.tasaExito,
    required this.diasTotales,
    required this.rachaActual,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      activeHabitsCount: json['activeHabitsCount'] ?? 0,
      tasaExito: json['tasaExito'] ?? 0,
      diasTotales: json['diasTotales'] ?? 0,
      rachaActual: json['rachaActual'] ?? 0,
    );
  }
}
