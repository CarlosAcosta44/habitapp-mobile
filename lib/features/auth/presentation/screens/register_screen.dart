import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';


const _kBlueBadge = Color(0xFF2D82FA);
const _kBlueBadgeBg = Color(0xFFEAF2FF);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _generoCtrl = TextEditingController(text: 'Masculino');
  final _dobCtrl = TextEditingController();
  
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _apellidoCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _generoCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debes aceptar los Términos de Servicio.'),
            backgroundColor: Colors.red.shade600,
          ),
        );
        return;
      }

      FocusScope.of(context).unfocus();
      ref.read(authProvider.notifier).register(
            _emailCtrl.text.trim(),
            _passCtrl.text,
            _nameCtrl.text.trim(),
            _apellidoCtrl.text.trim(),
            genero: _generoCtrl.text,
            fechanacimiento: _dobCtrl.text.isNotEmpty ? _dobCtrl.text : null,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue<bool>>(authProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar (Personalizado) ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                      onPressed: () => context.go('/login'),
                    ),
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // ── Contenido ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Icono Superior
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo-habitapp.png',
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.extension, color: Theme.of(context).colorScheme.primary, size: 32),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Badge Verde
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _kBlueBadgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_outline_rounded, color: _kBlueBadge, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Transformación Personal',
                            style: TextStyle(
                              color: _kBlueBadge,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Títulos
                    Text(
                      'Crea tu cuenta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Empieza hoy tu camino hacia una vida más plena\ny hábitos conscientes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                    ),
                    SizedBox(height: 28),

                    // Card del Formulario
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.03),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Campo Nombre ──
                            Text(
                              'Nombre completo',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            SizedBox(height: 8),
                            _StyledField(
                              controller: _nameCtrl,
                              hint: 'Marina',
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (v) => v!.isEmpty ? 'Ingresa tu nombre' : null,
                            ),
                            SizedBox(height: 16),

                            // ── Campo Apellido ──
                            Text(
                              'Apellido',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            SizedBox(height: 8),
                            _StyledField(
                              controller: _apellidoCtrl,
                              hint: 'Soler',
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (v) => v!.isEmpty ? 'Ingresa tu apellido' : null,
                            ),
                            SizedBox(height: 16),

                            // ── Campo Género y Fecha ──
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Género',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                      SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        initialValue: _generoCtrl.text,
                                        items: ['Masculino', 'Femenino', 'Otro', 'Prefiero no decirlo']
                                            .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
                                            .toList(),
                                        onChanged: (v) {
                                          if (v != null) setState(() => _generoCtrl.text = v);
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                        ),
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Fecha Nac.',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                      SizedBox(height: 8),
                                      _StyledField(
                                        controller: _dobCtrl,
                                        hint: 'YYYY-MM-DD',
                                        prefixIcon: Icons.cake_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),

                            // ── Campo Correo ──
                            Text(
                              'Correo electrónico',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            SizedBox(height: 8),
                            _StyledField(
                              controller: _emailCtrl,
                              hint: 'marina@ejemplo.com',
                              prefixIcon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Ingresa tu correo';
                                if (!v.contains('@')) return 'Correo inválido';
                                return null;
                              },
                            ),
                            SizedBox(height: 16),

                            // ── Campo Contraseña ──
                            Text(
                              'Contraseña segura',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            SizedBox(height: 8),
                            _StyledField(
                              controller: _passCtrl,
                              hint: '••••••••',
                              obscureText: _obscure,
                              prefixIcon: Icons.lock_outline_rounded,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                                if (v.length < 6) return 'Mínimo 6 caracteres';
                                return null;
                              },
                            ),
                            SizedBox(height: 8),
                            
                            // Requisitos contraseña
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Mínimo 8 caracteres', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                                Text('A-Z, 0-9, símbolos', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            SizedBox(height: 16),

                            // ── Campo Confirmar Contraseña ──
                            Text(
                              'Confirmar contraseña',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            SizedBox(height: 8),
                            _StyledField(
                              controller: _confirmPassCtrl,
                              hint: '••••••••',
                              obscureText: _obscureConfirm,
                              prefixIcon: Icons.restore_rounded,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                              ),
                              validator: (v) {
                                if (v != _passCtrl.text) return 'Las contraseñas no coinciden';
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            // ── Aceptar Términos ──
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _acceptTerms,
                                    activeColor: Theme.of(context).colorScheme.primary,
                                    side: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant, width: 1.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    onChanged: (v) => setState(() => _acceptTerms = v!),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                                      children: [
                                        TextSpan(text: 'Acepto los '),
                                        TextSpan(text: 'Términos de Servicio', style: TextStyle(color: _kBlueBadge, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                                        TextSpan(text: ' y la '),
                                        TextSpan(text: 'Política de Privacidad', style: TextStyle(color: _kBlueBadge, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                                        TextSpan(text: ' de HabitApp.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),

                            // ── Botón Crear Cuenta ──
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: authState.isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.surface,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                child: authState.isLoading
                                    ? SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.surface, strokeWidth: 2.5),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Crear Cuenta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward_rounded, size: 20),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(height: 24),

                            // ── Separador "O regístrate con" ──
                            Row(
                              children: [
                                Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('O regístrate con', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                                ),
                                Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
                              ],
                            ),
                            SizedBox(height: 20),

                            // ── Botones Sociales ──
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      elevation: 0,
                                      minimumSize: Size(0, 48),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: Image.asset(
                                      'assets/images/google_logo.png',
                                      width: 18,
                                      height: 18,
                                      errorBuilder: (context, error, stackTrace) => Icon(Icons.g_mobiledata_rounded, color: Colors.red, size: 22),
                                    ),
                                    label: Text('Google', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      elevation: 0,
                                      minimumSize: Size(0, 48),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: Icon(Icons.facebook, color: Colors.blue.shade700, size: 20),
                                    label: Text('Facebook', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 28),

                    // ── Inicia sesión ──
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          children: [
                            TextSpan(text: '¿Ya tienes una cuenta? '),
                            TextSpan(
                              text: 'Inicia sesión',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Widgets Auxiliares
// ─────────────────────────────────────────────────────────
class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const _StyledField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
        prefixIcon: Icon(prefixIcon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        suffixIcon: suffix,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
      ),
    );
  }
}
