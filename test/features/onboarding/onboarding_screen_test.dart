import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habitapp_frontend/core/network/dio_client.dart';
import 'package:habitapp_frontend/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:habitapp_frontend/features/onboarding/providers/onboarding_provider.dart';

class FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _store[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }
}

void main() {
  void configureMobileViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('OnboardingScreen y OnboardingProvider (UT-179 a UT-186)', () {
    // 1 (UT-179)
    testWidgets('UT-179: OnboardingScreen renderiza título de marca HabitApp y botón principal (US001)', (WidgetTester tester) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      expect(find.text('HabitApp'), findsOneWidget);
      expect(find.text('Continuar con correo'), findsOneWidget);
    });

    // 2 (UT-180)
    testWidgets('UT-180: OnboardingScreen muestra primer slide de creación de buenos hábitos', (WidgetTester tester) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      expect(
        find.text('Cambia tu vida incorporando poco a poco rutinas saludables.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });

    // 3 (UT-181)
    testWidgets('UT-181: OnboardingScreen permite deslizar al segundo slide de seguimiento de progreso', (WidgetTester tester) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(
        find.text('Cada día estás un paso más cerca de tu meta. ¡No te rindas!'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
    });

    // 4 (UT-182)
    testWidgets('UT-182: OnboardingScreen permite deslizar al tercer slide de comunidad', (WidgetTester tester) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(
        find.text('Comparte tus logros y motívate junto a otras personas.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.groups_rounded), findsOneWidget);
    });

    // 5 (UT-183)
    testWidgets('UT-183: OnboardingScreen renderiza 3 indicadores animados de página', (WidgetTester tester) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });

    // 6 (UT-184)
    testWidgets('UT-184: OnboardingScreen muestra enlaces legales de Términos y Política de privacidad', (WidgetTester tester) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: OnboardingScreen()),
        ),
      );

      expect(find.text('Términos de servicio'), findsOneWidget);
      expect(find.text('Política de privacidad'), findsOneWidget);
    });

    // 7 (UT-185)
    test('UT-185: OnboardingNotifier retorna false en primera visita cuando has_seen_onboarding no existe', () async {
      final fakeStorage = FakeSecureStorage();
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(fakeStorage),
        ],
      );
      addTearDown(container.dispose);

      final hasSeen = await container.read(onboardingProvider.future);
      expect(hasSeen, isFalse);
    });

    // 8 (UT-186)
    test('UT-186: OnboardingNotifier.completeOnboarding persiste flag true para omitir inducción en visitas recurrentes', () async {
      final fakeStorage = FakeSecureStorage();
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(fakeStorage),
        ],
      );
      addTearDown(container.dispose);

      await container.read(onboardingProvider.notifier).completeOnboarding();
      final stateVal = await container.read(onboardingProvider.future);
      final stored = await fakeStorage.read(key: 'has_seen_onboarding');

      expect(stateVal, isTrue);
      expect(stored, equals('true'));
    });
  });
}
