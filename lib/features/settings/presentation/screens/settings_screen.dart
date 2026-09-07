import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/providers/auth_provider.dart';
import '../../../profile/providers/profile_provider.dart';

const _kBlue = Color(0xFF2D82FA);
const _kPink = Color(0xFFF94C84);
const _kBg = Color(0xFFF7F7F9);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Estados locales (Mockup) para los selectores
  int _selectedTheme = 1; // 0: Oscuro, 1: Claro, 2: Auto
  bool _notificationsEnabled = true;
  int _selectedSound = 0; // 0: Campanas, 1: Naturaleza, 2: Silencio
  bool _appleHealthEnabled = true;
  bool _privateModeEnabled = true;
  bool _faceIdEnabled = false;

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('¿Estás seguro de que deseas salir de tu cuenta?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: _kTextGrey)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(authProvider.notifier).logout();
            },
            style: FilledButton.styleFrom(backgroundColor: _kPink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _kTextDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.hexagon_outlined, color: _kPink, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'HabitApp',
              style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 4),
            const Text(
              'Ajustes',
              style: TextStyle(color: _kTextGrey, fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: _kPink.withValues(alpha: 0.1),
              child: const Icon(Icons.person_outline, color: _kPink, size: 18),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(profileState),
            const SizedBox(height: 24),
            _buildSectionHeader('PREFERENCIAS DE LA APP', Icons.tune),
            _buildThemeCard(),
            const SizedBox(height: 12),
            _buildToggleCard('Activar notificaciones', 'Recibir avisos y recordatorios de\nhábitos', Icons.notifications_active_outlined, _notificationsEnabled, (v) => setState(() => _notificationsEnabled = v)),
            const SizedBox(height: 12),
            _buildSoundCard(),
            const SizedBox(height: 24),
            _buildSectionHeader('BIENESTAR Y PRIVACIDAD', Icons.shield_outlined),
            _buildPrivacyContainer(),
            const SizedBox(height: 24),
            _buildSectionHeader('ACOMPAÑAMIENTO', Icons.psychology_outlined),
            _buildCoachCard(),
            const SizedBox(height: 12),
            _buildHelpCard(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context, ref),
                icon: const Icon(Icons.logout, color: _kPink),
                label: const Text('Cerrar sesión', style: TextStyle(color: _kPink, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _kPink),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'HabitApp versión 2.4.1 (Build 418)\n© 2026 HabitApp Inc. Hecho con serenidad.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _kTextGrey, fontSize: 10),
              ),
            ),
            const SizedBox(height: 48), // Padding bottom for the BottomAppBar
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AsyncValue profileState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (profileState.value?.fotoperfil != null) ? NetworkImage(profileState.value!.fotoperfil!) : null,
                    child: (profileState.value?.fotoperfil == null) ? const Icon(Icons.person, color: Colors.grey, size: 28) : null,
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F8A5D),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (profileState.value != null) ? '${profileState.value!.nombre} ${profileState.value!.apellido}' : 'Cargando...',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: _kTextDark),
                    ),
                    Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: _kPink, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text(profileState.value?.nombrerol ?? 'Nivel 4 - Serenidad', style: const TextStyle(fontSize: 12, color: _kTextGrey)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _kBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, color: _kBlue, size: 14),
                    SizedBox(width: 4),
                    Text('24 días', style: TextStyle(color: _kBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/profile'),
                  icon: const Icon(Icons.edit, size: 16, color: _kTextDark),
                  label: const Text('Editar perfil', style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    backgroundColor: _kBg,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _kBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, color: _kTextDark, size: 20),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData trailingIcon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: _kTextGrey, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
          ),
          Icon(trailingIcon, color: Colors.grey.shade400, size: 18),
        ],
      ),
    );
  }

  Widget _buildThemeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _kPink.withValues(alpha: 0.1),
                child: const Icon(Icons.light_mode_outlined, color: _kPink, size: 18),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tema y Apariencia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _kTextDark)),
                    Text('Personaliza el contraste visual', style: TextStyle(fontSize: 12, color: _kTextGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _kBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildSegmentButton('Oscuro', Icons.dark_mode_outlined, 0, _selectedTheme, (i) => setState(() => _selectedTheme = i)),
                _buildSegmentButton('Claro', Icons.light_mode, 1, _selectedTheme, (i) => setState(() => _selectedTheme = i)),
                _buildSegmentButton('Auto', Icons.settings_suggest_outlined, 2, _selectedTheme, (i) => setState(() => _selectedTheme = i)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String text, IconData icon, int index, int selectedIndex, Function(int) onTap) {
    final isSelected = index == selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? _kBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected ? [BoxShadow(color: _kBlue.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : _kTextDark),
              const SizedBox(width: 6),
              Text(text, style: TextStyle(color: isSelected ? Colors.white : _kTextDark, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleCard(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE8F5E9),
            child: Icon(icon, color: const Color(0xFF0F8A5D), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _kTextDark)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: _kTextGrey)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _kBlue,
            inactiveTrackColor: Colors.grey.shade300,
            inactiveThumbColor: Colors.white,
          )
        ],
      ),
    );
  }

  Widget _buildSoundCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.orange.withValues(alpha: 0.1),
                child: const Icon(Icons.hearing_outlined, color: Colors.orange, size: 18),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sonidos de Bienestar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _kTextDark)),
                    Text('Tono de confirmación al completar hábitos', style: TextStyle(fontSize: 12, color: _kTextGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSoundButton('Campanas', Icons.graphic_eq, 0),
              const SizedBox(width: 10),
              _buildSoundButton('Naturaleza', Icons.park_outlined, 1),
              const SizedBox(width: 10),
              _buildSoundButton('Silencio', Icons.volume_off_outlined, 2),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSoundButton(String text, IconData icon, int index) {
    final isSelected = _selectedSound == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSound = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _kPink.withValues(alpha: 0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? _kPink : Colors.grey.shade300, width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? _kPink : _kTextGrey),
              const SizedBox(height: 6),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? _kPink : _kTextGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildPrivacyTile(
            'Apple Health / Google Fit',
            'Conectado - Pasos y sueño',
            Icons.favorite_border,
            Colors.blue,
            _appleHealthEnabled,
            (v) => setState(() => _appleHealthEnabled = v),
            subtitleDotColor: _kBlue,
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF3F3F3)),
          _buildPrivacyTile(
            'Modo Privado en Comunidad',
            'Compartir hábitos de forma anónima',
            Icons.visibility_off_outlined,
            Colors.black54,
            _privateModeEnabled,
            (v) => setState(() => _privateModeEnabled = v),
          ),
          const Divider(height: 1, indent: 70, color: Color(0xFFF3F3F3)),
          _buildPrivacyTile(
            'Bloqueo con FaceID / Huella',
            'Seguridad para tus reflexiones\nprivadas',
            Icons.fingerprint,
            _kPink,
            _faceIdEnabled,
            (v) => setState(() => _faceIdEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTile(String title, String subtitle, IconData icon, Color iconColor, bool value, Function(bool) onChanged, {Color? subtitleDotColor}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor.withValues(alpha: 0.1),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _kTextDark)),
                Row(
                  children: [
                    if (subtitleDotColor != null) ...[
                      Container(width: 4, height: 4, decoration: BoxDecoration(color: subtitleDotColor, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                    ],
                    Expanded(child: Text(subtitle, style: const TextStyle(fontSize: 11, color: _kTextGrey))),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _kBlue,
            inactiveTrackColor: Colors.grey.shade300,
            inactiveThumbColor: Colors.white,
          )
        ],
      ),
    );
  }

  Widget _buildCoachCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 12, color: Colors.orange.shade800),
                    const SizedBox(width: 4),
                    Text('Próxima sesión', style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Text('En 2 días', style: TextStyle(color: _kTextGrey, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: const AssetImage('assets/images/paisaje-dashboard.png'), // placeholder
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dra. Elena Vidal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _kTextDark)),
                    Text('Especialista en hábitos - Mindfulness', style: TextStyle(fontSize: 11, color: _kTextGrey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _kBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.event, color: _kBlue, size: 16),
                    SizedBox(width: 8),
                    Text('Jueves, 18:00 hrs (45 min)', style: TextStyle(color: _kTextDark, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('Ver enlace', style: TextStyle(color: _kPink, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _kBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.help_outline, color: _kTextDark, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Centro de Ayuda y\nPreguntas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _kTextDark, height: 1.2)),
                Text('Guías rápidas, FAQs y soporte técnico', style: TextStyle(fontSize: 11, color: _kTextGrey)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}
