import 'package:flutter/material.dart';
import '../widgets/onboarding_card.dart';
import '../widgets/page_indicator.dart';
import '../widgets/action_buttons.dart';

/// Pantalla principal de Pre-inicio / Carrusel de Bienvenida (Sprint 1 - Breiner).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _slides = const [
    OnboardingData(
      title: 'Construye Hábitos Positivos',
      description:
          'Diseña rutinas saludables y realiza un seguimiento diario de tus actividades de forma sencilla e intuitiva.',
      icon: Icons.track_changes_rounded,
      primaryColor: Color(0xFF2563EB), // Blue
    ),
    OnboardingData(
      title: 'Mantén tus Rachas y Puntos',
      description:
          'Gana puntos por cada hábito completado, sube de nivel y desbloquea logros mientras mantienes tus rachas activas.',
      icon: Icons.local_fire_department_rounded,
      primaryColor: Color(0xFFEA580C), // Orange
    ),
    OnboardingData(
      title: 'Comunidad y Retos',
      description:
          'Conéctate con otros usuarios, participa en retos grupales y recibe apoyo continuo para cumplir tus metas.',
      icon: Icons.groups_rounded,
      primaryColor: Color(0xFF16A34A), // Green
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onRegister() {
    // TODO: Navegar a la pantalla de registro vía GoRouter (Nicolas/Juan)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegar a Registro')),
    );
  }

  void _onLogin() {
    // TODO: Navegar a la pantalla de inicio de sesión vía GoRouter (Nicolas)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegar a Iniciar Sesión')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _onLogin,
                  child: const Text(
                    'Omitir',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // Carrusel de Diapositivas
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingCard(data: _slides[index]);
                },
              ),
            ),
            // Indicador de Puntos
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: PageIndicator(
                count: _slides.length,
                currentIndex: _currentPage,
                activeColor: _slides[_currentPage].primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            // Botones de Acción de Pie de Página
            ActionButtons(
              onRegisterPressed: _onRegister,
              onLoginPressed: _onLogin,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
