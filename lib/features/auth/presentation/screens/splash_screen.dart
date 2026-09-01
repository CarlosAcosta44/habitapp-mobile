import 'package:flutter/material.dart';

/// SplashScreen — Pantalla de carga inicial mientras se resuelve
/// el estado de autenticación y el flag de onboarding.
/// El router (GoRouter) se encarga de salir de esta pantalla
/// automáticamente una vez que ambos providers terminan de cargar.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF4B4EFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'HabitApp',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              color: Colors.white54,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
