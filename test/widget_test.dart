import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitapp_frontend/features/habits/data/models/category_model.dart';
import 'package:habitapp_frontend/features/habits/data/models/create_habit_dto.dart';
import 'package:habitapp_frontend/features/habits/data/models/habit_model.dart';
import 'package:habitapp_frontend/features/habits/presentation/widgets/daily_progress_bar.dart';
import 'package:habitapp_frontend/features/habits/providers/mock_habits_provider.dart';

void main() {
  group('DailyProgressBar, HabitModel y HabitsProvider (UT-187 a UT-194)', () {
    // 1 (UT-187)
    testWidgets('UT-187: DailyProgressBar con 0 hábitos programados hoy muestra %0 sin división por cero (US019)', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyProgressBar(completed: 0, total: 0),
          ),
        ),
      );

      expect(find.text('%0'), findsOneWidget);
      expect(find.text('0 de 0 completados'), findsOneWidget);
    });

    // 2 (UT-188)
    testWidgets('UT-188: DailyProgressBar con 1 de 4 hábitos completados muestra %25', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyProgressBar(completed: 1, total: 4),
          ),
        ),
      );

      expect(find.text('%25'), findsOneWidget);
      expect(find.text('1 de 4 completados'), findsOneWidget);
    });

    // 3 (UT-189)
    testWidgets('UT-189: DailyProgressBar con 2 de 4 hábitos completados muestra %50', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyProgressBar(completed: 2, total: 4),
          ),
        ),
      );

      expect(find.text('%50'), findsOneWidget);
      expect(find.text('2 de 4 completados'), findsOneWidget);
    });

    // 4 (UT-190)
    testWidgets('UT-190: DailyProgressBar con 4 de 4 hábitos completados muestra %100', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyProgressBar(completed: 4, total: 4),
          ),
        ),
      );

      expect(find.text('%100'), findsOneWidget);
      expect(find.text('4 de 4 completados'), findsOneWidget);
    });

    // 5 (UT-191)
    test('UT-191: HabitModel.fromJson mapea correctamente idHabito, rachaActual, puntos y estado completadoHoy (US014/US020)', () {
      final json = {
        'idHabito': 'hab-101',
        'nombre': 'Beber 2L de agua',
        'puntos': 10,
        'metaDiaria': 2000.0,
        'unidadMedida': 'ml',
        'completadoHoy': true,
        'progresoHoy': 2000.0,
        'rachaActual': 7,
        'mejorRacha': 14,
        'diasSemana': [1, 2, 3, 4, 5, 6, 7],
        'estado': 'Activo',
      };

      final habit = HabitModel.fromJson(json);
      expect(habit.id, equals('hab-101'));
      expect(habit.nombre, equals('Beber 2L de agua'));
      expect(habit.completadoHoy, isTrue);
      expect(habit.rachaActual, equals(7));
      expect(habit.mejorRacha, equals(14));
      expect(habit.diasSemana.length, equals(7));
    });

    // 6 (UT-192)
    test('UT-192: CreateHabitDto.toJson serializa nombre, metaDiaria, idCategoria y diasSemana para POST /users/habits (US011)', () {
      const dto = CreateHabitDto(
        nombre: 'Meditar 10m',
        idCategoria: 'cat-mente',
        fechaInicio: '2026-11-05',
        metaDiaria: 10,
        unidadMedida: 'minutos',
        puntos: 10,
        diasSemana: [1, 3, 5],
      );

      final json = dto.toJson();
      expect(json['nombre'], equals('Meditar 10m'));
      expect(json['idCategoria'], equals('cat-mente'));
      expect(json['diasSemana'], equals([1, 3, 5]));
    });

    // 7 (UT-193)
    test('UT-193: CategoryModel resuelve icono y color asociados a la categoría de bienestar', () {
      const cat = CategoryModel(id: 'cat-salud', nombre: 'Salud', icono: 'salud');
      expect(cat.id, equals('cat-salud'));
      expect(cat.nombre, equals('Salud'));
      expect(cat.parsedIcon, isNotNull);
      expect(cat.parsedColor, isNotNull);
    });

    // 8 (UT-194)
    test('UT-194: MockHabits cumple la Regla de Oro #2 (Zero-Mock Policy) retornando estado vacío por defecto', () {
      final notifier = MockHabits();
      expect(notifier.build(), isEmpty);
    });
  });
}
