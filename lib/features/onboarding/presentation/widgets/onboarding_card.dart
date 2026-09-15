import 'package:flutter/material.dart';

/// Modelo de datos para las diapositivas de onboarding.
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;

  OnboardingData({
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ilustración / Contenedor de Icono Principal
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: data.primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: data.primaryColor.withValues(alpha: 0.08),
                          blurRadius: 24,
                          spreadRadius: 6,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      data.icon,
                      size: 64,
                      color: data.primaryColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  // Título principal
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B), // Dark Slate
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Descripción explicativa
                  Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Color(0xFF64748B), // Muted Text Color
                      height: 1.4,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
