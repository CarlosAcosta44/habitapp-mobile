class RoutineSummary {
  final String id;
  final String title;
  final String description;
  final int totalExercises;

  RoutineSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.totalExercises,
  });

  factory RoutineSummary.fromJson(Map<String, dynamic> json) {
    final habitsList = json['routine_habits'] as List?;
    return RoutineSummary(
      id: (json['id'] ?? json['idrutina'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? json['objetivo'] ?? '').toString(),
      description: (json['description'] ?? json['descripcion'] ?? '').toString(),
      totalExercises:
          json['totalExercises'] as int? ?? habitsList?.length ?? 0,
    );
  }
}
