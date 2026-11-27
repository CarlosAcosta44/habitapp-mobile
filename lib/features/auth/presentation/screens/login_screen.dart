import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';


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

  void _openForgotPasswordSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ForgotPasswordSheet(
        initialEmail: _emailCtrl.text.trim(),
      ),
    );
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                      onPressed: () => context.go('/onboarding'),
                    ),
                  ),
                  Text(
                    'Login',
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
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
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
                                Icon(Icons.extension, color: Theme.of(context).colorScheme.primary, size: 32),
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
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: Theme.of(context).colorScheme.surface,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Títulos
                    Text(
                      '¡Hola de nuevo!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inicia sesión para continuar cuidando de tus\nhábitos y bienestar mental.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                    ),
                    const SizedBox(height: 28),

                    // Card del Formulario
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.03),
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
                            Text(
                              'Correo Electrónico',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurface,
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
                            Text(
                              'Contraseña',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Theme.of(context).colorScheme.onSurface,
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
                            const SizedBox(height: 16),

                            // ── Recordar datos & Olvidaste contraseña ──
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: Theme.of(context).colorScheme.primary,
                                    side: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (v) => setState(() => _rememberMe = v!),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Recordar mis datos',
                                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _openForgotPasswordSheet,
                                  child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.primary,
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
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).colorScheme.surface,
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
                                Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'O continúa con',
                                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                  ),
                                ),
                                Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // ── Botones Sociales ──
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await ref.read(authProvider.notifier).signInWithGoogle();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
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
                                    onPressed: () async {
                                      await ref.read(authProvider.notifier).signInWithFacebook();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
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
                        text: TextSpan(
                          style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          children: [
                            const TextSpan(text: '¿Aún no tienes cuenta? '),
                            TextSpan(
                              text: 'Regístrate gratis',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
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
                        Icon(Icons.shield_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Tus datos de salud mental están 100% encriptados y\nprotegidos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
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
      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
        prefixIcon: Icon(prefixIcon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        suffixIcon: suffix,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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

class _ForgotPasswordSheet extends ConsumerStatefulWidget {
  final String initialEmail;

  const _ForgotPasswordSheet({required this.initialEmail});

  @override
  ConsumerState<_ForgotPasswordSheet> createState() =>
      _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends ConsumerState<_ForgotPasswordSheet> {
  late final TextEditingController _emailCtrl;
  final _tokenCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  bool _codeSent = false;
  bool _loading = false;
  String? _errorMsg;
  String? _infoMsg;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _tokenCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMsg = 'Ingresa un correo electrónico válido.');
      return;
    }
    setState(() {
      _loading = true;
      _errorMsg = null;
      _infoMsg = null;
    });
    try {
      await ref.read(authProvider.notifier).requestPasswordReset(email);
      if (!mounted) return;
      setState(() {
        _codeSent = true;
        _loading = false;
        _infoMsg =
            'Enviamos las instrucciones y el código de recuperación a $email.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMsg = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _confirmNewPassword() async {
    final token = _tokenCtrl.text.trim();
    final newPass = _newPassCtrl.text;
    if (token.isEmpty) {
      setState(() => _errorMsg = 'Pega el código/token recibido en tu correo.');
      return;
    }
    if (newPass.length < 6) {
      setState(
          () => _errorMsg = 'La nueva contraseña debe tener mínimo 6 caracteres.');
      return;
    }
    setState(() {
      _loading = true;
      _errorMsg = null;
    });
    try {
      await ref
          .read(authProvider.notifier)
          .confirmPasswordReset(token, newPass);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '¡Contraseña actualizada exitosamente! Ya puedes iniciar sesión.'),
          backgroundColor: _kGreenBadge,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMsg = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _codeSent ? 'Restablecer Contraseña' : 'Recuperar Contraseña',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _codeSent
                  ? 'Revisa tu bandeja de entrada. Puedes usar el enlace del correo o pegar aquí el token recibido:'
                  : 'Ingresa tu correo registrado y te enviaremos un enlace y código de recuperación.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMsg != null) ...[
              Text(
                _errorMsg!,
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (_infoMsg != null) ...[
              Text(
                _infoMsg!,
                style: const TextStyle(
                  color: _kGreenBadge,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (!_codeSent) ...[
              _StyledField(
                controller: _emailCtrl,
                hint: 'tu-correo@ejemplo.com',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                      _loading ? 'Enviando...' : 'Enviar correo de recuperación'),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _codeSent = true),
                child: const Text('Ya tengo un código de recuperación'),
              ),
            ] else ...[
              _StyledField(
                controller: _tokenCtrl,
                hint: 'Pega aquí el token recibido por correo',
                prefixIcon: Icons.vpn_key_outlined,
              ),
              const SizedBox(height: 12),
              _StyledField(
                controller: _newPassCtrl,
                hint: 'Nueva contraseña (mínimo 6 caracteres)',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _confirmNewPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                      _loading ? 'Actualizando...' : 'Actualizar contraseña'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
