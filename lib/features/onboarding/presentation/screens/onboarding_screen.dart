import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/onboarding_provider.dart';

// ─────────────────────────────────────────────────────────
//  Modelo de datos para cada slide del carrusel
// ─────────────────────────────────────────────────────────
class _SlideData {
  final String title;
  final String description;
  final List<_FloatingCard> cards;

  const _SlideData({
    required this.title,
    required this.description,
    required this.cards,
  });
}

class _FloatingCard {
  final String emoji;
  final double topFraction;
  final double leftFraction;
  final bool alignRight;

  const _FloatingCard({
    required this.emoji,
    required this.topFraction,
    required this.leftFraction,
    this.alignRight = false,
  });
}

// ─────────────────────────────────────────────────────────
//  OnboardingScreen — Pantalla principal del carrusel
// ─────────────────────────────────────────────────────────
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _slides = [
    _SlideData(
      title: 'Crea buenos\nhábitos',
      description: 'Cambia tu vida incorporando poco a poco hábitos saludables',
      cards: [
        _FloatingCard(emoji: '✅', topFraction: 0.08, leftFraction: 0.45, alignRight: true),
        _FloatingCard(emoji: '😊', topFraction: 0.14, leftFraction: 0.62, alignRight: true),
        _FloatingCard(emoji: '✅', topFraction: 0.24, leftFraction: 0.15),
        _FloatingCard(emoji: '😄', topFraction: 0.28, leftFraction: 0.05),
        _FloatingCard(emoji: '✅', topFraction: 0.38, leftFraction: 0.22),
        _FloatingCard(emoji: '🧑', topFraction: 0.40, leftFraction: 0.10),
      ],
    ),
    _SlideData(
      title: 'Sigue tu\nprogreso',
      description: 'Cada día estás un paso más cerca de tu meta. ¡No te rindas!',
      cards: [
        _FloatingCard(emoji: '🏃', topFraction: 0.06, leftFraction: 0.30),
        _FloatingCard(emoji: '💧', topFraction: 0.16, leftFraction: 0.10),
        _FloatingCard(emoji: '🚶', topFraction: 0.27, leftFraction: 0.10),
        _FloatingCard(emoji: '🧘', topFraction: 0.38, leftFraction: 0.10),
      ],
    ),
    _SlideData(
      title: 'Mantente unido\ny fuerte',
      description:
          'Encuentra amigos para conversar sobre temas en común. Completen desafíos juntos.',
      cards: [
        _FloatingCard(emoji: '🧑‍🦱', topFraction: 0.06, leftFraction: 0.40),
        _FloatingCard(emoji: '👱', topFraction: 0.08, leftFraction: 0.05),
        _FloatingCard(emoji: '22', topFraction: 0.22, leftFraction: 0.30),
        _FloatingCard(emoji: '👩', topFraction: 0.22, leftFraction: 0.68),
        _FloatingCard(emoji: '👩‍🦰', topFraction: 0.40, leftFraction: 0.35),
      ],
    ),
  ];

  Future<void> _complete() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) context.go('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Fondo degradado azul (fiel al diseño Figma) ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5356FF), Color(0xFF3A3DC8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ── Decoración: burbujas de fondo ──
          Positioned(
            top: -60,
            right: -60,
            child: _BlurCircle(
                size: 200, color: const Color(0xFF4B4EFC).withValues(alpha: 0.3)),
          ),
          Positioned(
            top: 100,
            left: -80,
            child: _BlurCircle(
                size: 180, color: const Color(0xFF4B4EFC).withValues(alpha: 0.2)),
          ),

          // ── Contenido principal ──
          SafeArea(
            child: Column(
              children: [
                // Botón Omitir
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _complete,
                    child: const Text(
                      'Omitir',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                // Carrusel de diapositivas
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (ctx, i) => _SlidePage(data: _slides[i]),
                  ),
                ),

                // Indicador de puntos animado
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // ── Botones de acción ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Continuar con correo electrónico
                      _PillButton(
                        onTap: _complete,
                        backgroundColor: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.arrow_forward,
                                color: Color(0xFF4B4EFC), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Continuar con correo electrónico',
                              style: TextStyle(
                                color: Color(0xFF4B4EFC),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Apple / Google / Facebook
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              label: 'Apple',
                              icon: Icons.apple,
                              onTap: _complete,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _SocialButton(
                              label: 'Google',
                              icon: Icons.g_mobiledata_rounded,
                              onTap: _complete,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _SocialButton(
                              label: 'Facebook',
                              icon: Icons.facebook,
                              onTap: _complete,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Revisa nuestros Términos y condiciones',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  _SlidePage — Ilustración + texto de cada diapositiva
// ─────────────────────────────────────────────────────────
class _SlidePage extends StatelessWidget {
  final _SlideData data;
  const _SlidePage({required this.data});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zona ilustrativa (parte superior con emojis flotantes)
          Expanded(
            child: Stack(
              children: data.cards
                  .map(
                    (c) => Positioned(
                      top: height * 0.36 * c.topFraction,
                      left:
                          c.alignRight ? null : width * c.leftFraction,
                      right: c.alignRight
                          ? width * (1 - c.leftFraction - 0.25)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          c.emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // Título grande
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          // Descripción
          Text(
            data.description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.80),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Widgets auxiliares privados
// ─────────────────────────────────────────────────────────
class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _PillButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget child;

  const _PillButton({
    required this.onTap,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      );
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.black87),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
}
