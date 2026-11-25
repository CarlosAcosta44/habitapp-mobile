import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../dashboard/data/repositories/quotes_repository.dart';
import '../../providers/auth_provider.dart';
import '../../providers/splash_provider.dart';

const _kMorningSplashAsset = 'assets/images/Mañana.jpg';

class SplashData {
  static Quote? dailyQuote;
  static String splashImage = _kMorningSplashAsset;
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _imagePath = _kMorningSplashAsset;
  Quote? _quote;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _determineTimeOfDay();
    _loadDataAndNavigate();
  }

  void _determineTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      _imagePath = _kMorningSplashAsset;
    } else if (hour >= 12 && hour < 19) {
      _imagePath = 'assets/images/Tarde.jpg';
    } else {
      _imagePath = 'assets/images/Noche.jpg';
    }
  }

  Future<void> _loadDataAndNavigate() async {
    _animationController.forward();
    
    // Al mismo tiempo que animamos, cargamos la frase del backend y verificamos autenticación
    try {
      final quote = await ref.read(quotesServiceProvider).getDailyQuote();
      if (mounted) {
        setState(() {
          _quote = quote;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _quote = Quote(phrase: 'Transforma tus metas en hábitos y tus hábitos en realidad.', author: 'HabitApp');
        });
      }
    }

    // Actualizamos los providers globales para el dashboard
    SplashData.dailyQuote = _quote;
    SplashData.splashImage = _imagePath;

    // Aseguramos que la pantalla de carga dure al menos 3.5 segundos para que se aprecie
    await Future.delayed(const Duration(milliseconds: 3500));

    if (!mounted) return;

    // Liberamos el bloqueo del splash
    ref.read(splashProvider.notifier).complete();

    // Verificamos si está logueado para redirigir
    final authState = await ref.read(authProvider.future);
    if (!mounted) return;
    if (authState) {
      context.go('/'); // The path in app_router is '/' not '/dashboard'
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo adaptativa
          Image.asset(
            _imagePath,
            fit: BoxFit.cover,
          ),
          
          // Gradiente oscuro para que el texto resalte
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Contenido Animado (Frase)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/logo-habitapp.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'HabitApp',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 15, offset: Offset(0, 3))],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _quote?.phrase ?? 'Cargando tu día...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 2))],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _quote?.author != null ? '- ${_quote!.author}' : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
