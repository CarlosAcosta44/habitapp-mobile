import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/onboarding_provider.dart';

// ─────────────────────────────────────────────────────────
//  Datos de cada slide
// ─────────────────────────────────────────────────────────
class _Slide {
  final String titleNormal;
  final String titleHighlight;
  final String subtitle;
  final IconData icon;

  const _Slide({
    required this.titleNormal,
    required this.titleHighlight,
    required this.subtitle,
    required this.icon,
  });
}

const _kPrimaryPink = Color(0xFFE22D6F); // Color rosa/magenta del botón
const _kHighlightBlue = Color(0xFF2D82FA); // Color azul del texto
const _kBackgroundLight = Colors.white;
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);

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
      titleNormal: 'Cultiva tu\n',
      titleHighlight: 'bienestar mental',
      subtitle:
          'Pequeñas rutinas y apoyo profesional para una mente en calma y una vida plena.',
      icon: Icons.psychology_rounded,
    ),
    _Slide(
      titleNormal: 'Crea buenos\n',
      titleHighlight: 'hábitos',
      subtitle: 'Cambia tu vida incorporando poco a poco rutinas saludables.',
      icon: Icons.check_circle_outline_rounded,
    ),
    _Slide(
      titleNormal: 'Sigue tu\n',
      titleHighlight: 'progreso',
      subtitle: 'Cada día estás un paso más cerca de tu meta. ¡No te rindas!',
      icon: Icons.bar_chart_rounded,
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
    await _continueWithEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header (Logo) ──
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/play_store_icon.png',
                    width: 28,
                    height: 28,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.extension, color: _kHighlightBlue, size: 28),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'HabitApp',
                    style: TextStyle(
                      color: _kTextDark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ── Slides (Ilustración y Texto) ──
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder de ilustración (Ahora usará una imagen real)
                        Container(
                          width: double.infinity,
                          height: 240,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/play_store_icon.png',
                            fit: BoxFit.contain,
                            // Si la imagen no está aún, mostrará un error en pantalla (esto te avisará que falta).
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(slide.icon, size: 120, color: _kHighlightBlue),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Título
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              color: _kTextDark,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                            children: [
                              TextSpan(text: slide.titleNormal),
                              TextSpan(
                                text: slide.titleHighlight,
                                style: const TextStyle(color: _kHighlightBlue),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Subtítulo
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _kTextGrey,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Indicador de página ──
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == index
                          ? _kHighlightBlue
                          : Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // ── Botones y Footer ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Botón principal
                  ElevatedButton(
                    onPressed: _continueWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kHighlightBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail_outline_rounded, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Continuar con correo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Botones sociales
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          imageAsset: 'assets/images/google_logo.png',
                          fallbackIcon: Icons.g_mobiledata_rounded,
                          color: Colors.red,
                          onTap: _continueWithSocial,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SocialButton(
                          fallbackIcon: Icons.apple,
                          color: Colors.black,
                          onTap: _continueWithSocial,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Términos y condiciones
                  Text(
                    'Al continuar aceptas nuestros',
                    style: TextStyle(
                      color: _kTextGrey.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Términos de servicio',
                        style: TextStyle(
                          color: _kHighlightBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' y ',
                        style: TextStyle(
                          color: _kTextGrey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Política de privacidad',
                        style: TextStyle(
                          color: _kHighlightBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  _SocialButton
// ─────────────────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final IconData fallbackIcon;
  final String? imageAsset;
  final Color color;
  final VoidCallback onTap;

  const _SocialButton({
    required this.fallbackIcon,
    this.imageAsset,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(28),
        ),
        alignment: Alignment.center,
        child: imageAsset != null
            ? Image.asset(
                imageAsset!,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(fallbackIcon, size: 28, color: color),
              )
            : Icon(fallbackIcon, size: 28, color: color),
      ),
    );
  }
}
