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
    return RoutineSummary(
      id: json['id'] as String,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      totalExercises: json['totalExercises'] as int? ?? 0,
    );
  }
}
