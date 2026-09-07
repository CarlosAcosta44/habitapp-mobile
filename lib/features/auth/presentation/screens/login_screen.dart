import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';

const _kBlue = Color(0xFF2D82FA);
const _kBg = Color(0xFFF7F7F9);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);
const _kFieldBg = Color(0xFFF3F3F3);
const _kGreenBadge = Color(0xFF0F8A5D);

// ─────────────────────────────────────────────────────────
//  LoginScreen
// ─────────────────────────────────────────────────────────
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ref.read(authProvider.notifier).login(
            _emailCtrl.text.trim(),
            _passCtrl.text,
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
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar (Personalizado) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: _kTextDark),
                      onPressed: () => context.go('/onboarding'),
                    ),
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _kTextDark,
                    ),
                  ),
                ],
              ),
            ),

            // ── Contenido ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Avatar Logo con Badge
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/logo-habitapp.png',
                            width: 44,
                            height: 44,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.extension, color: _kBlue, size: 32),
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: _kGreenBadge,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Títulos
                    const Text(
                      '¡Hola de nuevo!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: _kTextDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Inicia sesión para continuar cuidando de tus\nhábitos y bienestar mental.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: _kTextGrey, height: 1.4),
                    ),
                    const SizedBox(height: 28),

                    // Card del Formulario
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Campo Correo ──
                            const Text(
                              'Correo Electrónico',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: _kTextDark,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                            const SizedBox(height: 20),

                            // ── Campo Contraseña ──
                            const Text(
                              'Contraseña',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: _kTextDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _StyledField(
                              controller: _passCtrl,
                              hint: '••••••••',
                              obscureText: _obscure,
                              prefixIcon: Icons.lock_outline_rounded,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: Colors.grey.shade500,
                                ),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                                if (v.length < 6) return 'Mínimo 6 caracteres';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // ── Recordar datos & Olvidaste contraseña ──
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: _kBlue,
                                    side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (v) => setState(() => _rememberMe = v!),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Recordar mis datos',
                                  style: TextStyle(fontSize: 13, color: _kTextGrey),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _kBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // ── Botón Iniciar Sesión ──
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: authState.isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _kBlue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                child: authState.isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward_rounded, size: 20),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ── Separador "O continúa con" ──
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'O continúa con',
                                    style: TextStyle(fontSize: 12, color: _kTextGrey),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // ── Botones Sociales ──
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _kFieldBg,
                                      foregroundColor: _kTextDark,
                                      elevation: 0,
                                      minimumSize: const Size(0, 48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: Image.asset(
                                      'assets/images/google_logo.png',
                                      width: 18,
                                      height: 18,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.g_mobiledata_rounded,
                                              color: Colors.red, size: 22),
                                    ),
                                    label: const Text(
                                      'Google',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _kFieldBg,
                                      foregroundColor: _kTextDark,
                                      elevation: 0,
                                      minimumSize: const Size(0, 48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: Icon(Icons.facebook, color: Colors.blue.shade700, size: 20),
                                    label: const Text(
                                      'Facebook',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Regístrate gratis ──
                    GestureDetector(
                      onTap: () => context.go('/register'),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 14, color: _kTextGrey),
                          children: [
                            TextSpan(text: '¿Aún no tienes cuenta? '),
                            TextSpan(
                              text: 'Regístrate gratis',
                              style: TextStyle(color: _kBlue, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Escudo de Seguridad ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shield_outlined, size: 16, color: _kTextGrey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Tus datos de salud mental están 100% encriptados y\nprotegidos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: _kTextGrey.withValues(alpha: 0.8)),
                          ),
                        ),
                      ],
                    ),
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
      style: const TextStyle(fontSize: 14, color: _kTextDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon: Icon(prefixIcon, size: 20, color: Colors.grey.shade600),
        suffixIcon: suffix,
        filled: true,
        fillColor: _kFieldBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBlue, width: 1.5),
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
