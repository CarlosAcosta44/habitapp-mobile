import 'package:flutter/material.dart';

/// Modelo de datos para las diapositivas de onboarding.
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
  });
}

/// Widget para cada tarjeta individual del carrusel de bienvenida.
class OnboardingCard extends StatelessWidget {
  final OnboardingData data;

  const OnboardingCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ilustración / Contenedor de Icono Principal
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: data.primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: data.primaryColor.withValues(alpha: 0.08),
                  blurRadius: 24,
                  spreadRadius: 8,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 88,
              color: data.primaryColor,
            ),
          ),
          const SizedBox(height: 40),
          // Título principal
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B), // Dark Slate
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // Descripción explicativa
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B), // Muted Text Color
              height: 1.5,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
