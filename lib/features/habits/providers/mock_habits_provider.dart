import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockHabit {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final double initialProgress;
  final bool isCompleted;

  MockHabit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.initialProgress = 0.0,
    this.isCompleted = false,
  });

  MockHabit copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    double? initialProgress,
    bool? isCompleted,
  }) {
    return MockHabit(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      initialProgress: initialProgress ?? this.initialProgress,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class MockHabits extends Notifier<List<MockHabit>> {
  @override
  List<MockHabit> build() {
    // Política Zero-Mock Data (Regla de Oro #2): Estado inicial vacío sin datos quemados.
    return [];
  }

  void toggleHabit(String id) {
    state = state.map((habit) {
      if (habit.id == id) {
        return habit.copyWith(isCompleted: !habit.isCompleted);
      }
      return habit;
    }).toList();
  }
}

final mockHabitsProvider = NotifierProvider<MockHabits, List<MockHabit>>(() {
  return MockHabits();
});
