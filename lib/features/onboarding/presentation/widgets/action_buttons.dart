import 'package:flutter/material.dart';

/// Botones de acción inferiores para el flujo de bienvenida (Crear cuenta e Iniciar sesión).
class ActionButtons extends StatelessWidget {
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginPressed;

  const ActionButtons({
    super.key,
    required this.onRegisterPressed,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón Primario: Crear Cuenta
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onRegisterPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2563EB), // Primary Blue
                foregroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Crear Cuenta'),
            ),
          ),
          SizedBox(height: 12),
          // Botón Secundario: Iniciar Sesión
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: onLoginPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF1E293B),
                side: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text('Ya tengo una cuenta'),
            ),
          ),
        ],
      ),
    );
  }
}
