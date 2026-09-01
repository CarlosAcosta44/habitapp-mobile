import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/onboarding_provider.dart';

// ─────────────────────────────────────────────────────────
//  Datos de cada slide
// ─────────────────────────────────────────────────────────
class _Slide {
  final String title;
  final String subtitle;
  final String illustration; // emoji / ícono representativo

  const _Slide({
    required this.title,
    required this.subtitle,
    required this.illustration,
  });
}

const _kBlue = Color(0xFF4B4EFC);
const _kBlueMid = Color(0xFF5356FF);
const _kBlueDark = Color(0xFF3A3DC8);

// ─────────────────────────────────────────────────────────
//  OnboardingScreen
// ─────────────────────────────────────────────────────────
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      title: 'Crea buenos\nhábitos',
      subtitle: 'Cambia tu vida incorporando poco a poco hábitos saludables',
      illustration: '✅',
    ),
    _Slide(
      title: 'Sigue tu\nprogreso',
      subtitle: 'Cada día estás un paso más cerca de tu meta. ¡No te rindas!',
      illustration: '📊',
    ),
    _Slide(
      title: 'Mantente unido\ny fuerte',
      subtitle:
          'Encuentra amigos para conversar sobre temas en común. Completen desafíos juntos.',
      illustration: '🤝',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continueWithEmail() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) context.go('/login');
  }

  Future<void> _continueWithSocial() async {
    // Por ahora lleva al mismo flujo hasta que el módulo social esté completo
    await _continueWithEmail();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Fondo degradado azul exacto del diseño ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_kBlueMid, _kBlueDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── Círculos decorativos de fondo ──
          Positioned(
            top: -80,
            right: -80,
            child: _Circle(size: 260, color: Colors.white.withValues(alpha: 0.06)),
          ),
          Positioned(
            top: size.height * 0.15,
            left: -60,
            child: _Circle(size: 160, color: Colors.white.withValues(alpha: 0.05)),
          ),
          Positioned(
            bottom: size.height * 0.28,
            right: -40,
            child: _Circle(size: 120, color: Colors.white.withValues(alpha: 0.05)),
          ),

          // ── Contenido ──
          SafeArea(
            child: Column(
              children: [
                // ── Barra superior: Omitir ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _continueWithEmail,
                      child: Text(
                        'Omitir',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Zona de ilustración (ocupa ~40% de la pantalla) ──
                SizedBox(
                  height: size.height * 0.38,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (_, i) => _IllustrationSlide(
                      slide: _slides[i],
                      slideIndex: i,
                    ),
                  ),
                ),

                // ── Texto título + descripción ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(_page),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _slides[_page].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _slides[_page].subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 14,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Indicador de puntos ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    final active = i == _page;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 24.0 : 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const Spacer(),

                // ── Botones de acción ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Column(
                    children: [
                      // Botón principal: Continuar con correo
                      _ActionButton(
                        onTap: _continueWithEmail,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_forward_rounded,
                                size: 18, color: _kBlue),
                            const SizedBox(width: 8),
                            const Text(
                              'Continuar con correo electrónico',
                              style: TextStyle(
                                color: _kBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Fila de redes sociales
                      Row(
                        children: [
                          Expanded(
                            child: _SocialChip(
                              icon: Icons.apple,
                              label: 'Apple',
                              onTap: _continueWithSocial,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _SocialChip(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                              onTap: _continueWithSocial,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _SocialChip(
                              icon: Icons.facebook,
                              label: 'Facebook',
                              onTap: _continueWithSocial,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Nota legal
                      Text(
                        'Revisa nuestros Términos y condiciones',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.50),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  _IllustrationSlide  — zona visual de cada slide
// ─────────────────────────────────────────────────────────
class _IllustrationSlide extends StatelessWidget {
  final _Slide slide;
  final int slideIndex;

  const _IllustrationSlide({required this.slide, required this.slideIndex});

  @override
  Widget build(BuildContext context) {
    // Floating cards ficticias que simulan los elementos del diseño Figma
    final floatingItems = _buildItems(slideIndex);

    return Stack(
      children: floatingItems,
    );
  }

  List<Widget> _buildItems(int index) {
    switch (index) {
      case 0:
        return [
          _FloatItem(top: 30, right: 40,
              child: _HabitCard(emoji: '✅', lines: 2)),
          _FloatItem(top: 90, left: 30,
              child: _AvatarBubble('😊')),
          _FloatItem(top: 130, right: 60,
              child: _HabitCard(emoji: '✅', lines: 1)),
          _FloatItem(top: 185, left: 50,
              child: _AvatarBubble('🧑')),
          _FloatItem(top: 210, right: 50,
              child: _HabitCard(emoji: '✅', lines: 2)),
        ];
      case 1:
        return [
          _FloatItem(top: 20, left: 60,
              child: _HabitCard(emoji: '🏃', lines: 2, label: 'Retos')),
          _FloatItem(top: 90, left: 30,
              child: _HabitCard(emoji: '💧', lines: 1, label: 'Hábitos')),
          _FloatItem(top: 150, left: 30,
              child: _HabitCard(emoji: '🚶', lines: 1)),
          _FloatItem(top: 210, left: 30,
              child: _HabitCard(emoji: '🧘', lines: 1)),
        ];
      case 2:
        return [
          _FloatItem(top: 20, left: 80, child: _AvatarBubble('🧑‍🦱')),
          _FloatItem(top: 30, left: 20, child: _AvatarBubble('👱')),
          _FloatItem(top: 110, left: 60,
              child: _RachaCard()),
          _FloatItem(top: 110, right: 30, child: _AvatarBubble('👩')),
          _FloatItem(top: 210, left: 100, child: _AvatarBubble('👩‍🦰')),
        ];
      default:
        return [];
    }
  }
}

class _FloatItem extends StatelessWidget {
  final double? top, left, right;
  final Widget child;

  const _FloatItem({this.top, this.left, this.right, required this.child});

  @override
  Widget build(BuildContext context) => Positioned(
        top: top,
        left: left,
        right: right,
        child: child,
      );
}

class _HabitCard extends StatelessWidget {
  final String emoji;
  final int lines;
  final String? label;

  const _HabitCard({required this.emoji, required this.lines, this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label != null)
                  Text(label!,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 9,
                          letterSpacing: 0.5)),
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                if (lines > 1) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
}

class _AvatarBubble extends StatelessWidget {
  final String emoji;
  const _AvatarBubble(this.emoji);

  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      );
}

class _RachaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('DÍA DE\nMEJOR\nRACHA',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54)),
            SizedBox(height: 4),
            Text('22',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _kBlue)),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────
//  Auxiliares compartidos
// ─────────────────────────────────────────────────────────
class _Circle extends StatelessWidget {
  final double size;
  final Color color;
  const _Circle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final Widget child;
  const _ActionButton({required this.onTap, required this.color, required this.child});

  @override
  Widget build(BuildContext context) => Material(
        color: color,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 52,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      );
}

class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: Colors.black87),
                const SizedBox(width: 4),
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ],
            ),
          ),
        ),
      );
}
