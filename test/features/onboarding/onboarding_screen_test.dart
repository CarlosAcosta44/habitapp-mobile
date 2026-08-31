import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitapp_frontend/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen renders slides and action buttons correctly',
      (WidgetTester tester) async {
    // 1. Build OnboardingScreen inside a MaterialApp wrapper
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    // 2. Verify that the first slide title is present
    expect(find.text('Construye Hábitos Positivos'), findsOneWidget);
    expect(find.text('Crear Cuenta'), findsOneWidget);
    expect(find.text('Ya tengo una cuenta'), findsOneWidget);
    expect(find.text('Omitir'), findsOneWidget);

    // 3. Swipe left to navigate to the second slide
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    // 4. Verify that the second slide title appears
    expect(find.text('Mantén tus Rachas y Puntos'), findsOneWidget);

    // 5. Swipe left again to navigate to the third slide
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    // 6. Verify that the third slide title appears
    expect(find.text('Comunidad y Retos'), findsOneWidget);
  });
}
