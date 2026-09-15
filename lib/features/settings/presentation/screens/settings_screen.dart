import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/providers/auth_provider.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../../../core/theme/theme_provider.dart';


class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Estados locales (Mockup) para los selectores
  bool _notificationsEnabled = true;
  int _selectedSound = 0; // 0: Campanas, 1: Naturaleza, 2: Silencio
  bool _appleHealthEnabled = true;
  bool _privateModeEnabled = true;

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('¿Estás seguro de que deseas salir de tu cuenta?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(authProvider.notifier).logout();
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final userStatsAsync = ref.watch(profileStatsProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-habitapp.png',
              width: 24,
              height: 24,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.extension, color: Theme.of(context).colorScheme.primary, size: 24),
            ),
            SizedBox(width: 8),
            Text(
              'HabitApp',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(width: 4),
            Text(
              'Ajustes',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ],
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(profileState, userStatsAsync),
            SizedBox(height: 24),
            _buildSectionHeader('PREFERENCIAS DE LA APP', Icons.tune),
            _buildThemeCard(themeMode),
            SizedBox(height: 12),
            _buildToggleCard('Activar notificaciones', 'Recibir avisos y recordatorios de\nhábitos', Icons.notifications_active_outlined, _notificationsEnabled, (v) => setState(() => _notificationsEnabled = v)),
            SizedBox(height: 12),
            _buildSoundCard(),
            SizedBox(height: 24),
            _buildSectionHeader('BIENESTAR Y PRIVACIDAD', Icons.shield_outlined),
            _buildPrivacyContainer(),
            SizedBox(height: 24),
            _buildSectionHeader('ACOMPAÑAMIENTO', Icons.psychology_outlined),
            _buildCoachCard(),
            SizedBox(height: 12),
            _buildHelpCard(),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context, ref),
                icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.secondary),
                label: Text('Cerrar sesión', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'HabitApp versión 2.4.1 (Build 418)\n© 2026 HabitApp Inc. Hecho con serenidad.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 10),
              ),
            ),
            SizedBox(height: 48), // Padding bottom for the BottomAppBar
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AsyncValue profileState, AsyncValue userStatsAsync) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.02), blurRadius: 10, offset: Offset(0, 4))],
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
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    backgroundImage: (profileState.value?.fotoperfil != null) ? NetworkImage(profileState.value!.fotoperfil!) : null,
                    child: (profileState.value?.fotoperfil == null) ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 28) : null,
                  ),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Color(0xFF0F8A5D),
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                    ),
                  )
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (profileState.value != null) ? '${profileState.value!.nombre} ${profileState.value!.apellido}' : 'Cargando...',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Row(
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle)),
                        SizedBox(width: 6),
                        Text(profileState.value?.nombrerol ?? 'Nivel 4 - Serenidad', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, color: Theme.of(context).colorScheme.primary, size: 14),
                    SizedBox(width: 4),
                    Text('${userStatsAsync.value?.rachaActual ?? 0} días', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/profile'),
                  icon: Icon(Icons.visibility_outlined, size: 16, color: Theme.of(context).colorScheme.onSurface),
                  label: Text('Ver perfil', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.share_outlined, color: Theme.of(context).colorScheme.onSurface, size: 20),
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
      padding: EdgeInsets.only(bottom: 12, left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
          ),
          Icon(trailingIcon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
        ],
      ),
    );
  }

  Widget _buildThemeCard(ThemeMode currentThemeMode) {
    int selectedIndex = currentThemeMode == ThemeMode.dark ? 0 
                      : currentThemeMode == ThemeMode.light ? 1 
                      : 2;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                child: Icon(Icons.light_mode_outlined, color: Theme.of(context).colorScheme.secondary, size: 18),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tema y Apariencia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                    Text('Personaliza el contraste visual', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildSegmentButton('Oscuro', Icons.dark_mode_outlined, 0, selectedIndex, (i) => ref.read(themeProvider.notifier).updateTheme(ThemeMode.dark)),
                _buildSegmentButton('Claro', Icons.light_mode, 1, selectedIndex, (i) => ref.read(themeProvider.notifier).updateTheme(ThemeMode.light)),
                _buildSegmentButton('Auto', Icons.settings_suggest_outlined, 2, selectedIndex, (i) => ref.read(themeProvider.notifier).updateTheme(ThemeMode.system)),
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
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 4, offset: Offset(0, 2))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface),
              SizedBox(width: 6),
              Text(text, style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleCard(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(icon, color: Color(0xFF0F8A5D), size: 18),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Theme.of(context).colorScheme.surface,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
            inactiveThumbColor: Theme.of(context).colorScheme.surface,
          )
        ],
      ),
    );
  }

  Widget _buildSoundCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                child: Icon(Icons.hearing_outlined, color: Colors.orange, size: 18),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sonidos de Bienestar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                    Text('Tono de confirmación al completar hábitos', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildSoundButton('Campanas', Icons.graphic_eq, 0),
              SizedBox(width: 10),
              _buildSoundButton('Naturaleza', Icons.park_outlined, 1),
              SizedBox(width: 10),
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
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.outlineVariant, width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurfaceVariant),
              SizedBox(height: 6),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurfaceVariant,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildPrivacyTile(
            'Apple Health / Google Fit',
            'Conectado - Pasos y sueño',
            Icons.favorite_border,
            Theme.of(context).colorScheme.primary,
            _appleHealthEnabled,
            (v) => setState(() => _appleHealthEnabled = v),
            subtitleDotColor: Theme.of(context).colorScheme.primary,
          ),
          Divider(height: 1, indent: 24, endIndent: 24, color: Theme.of(context).colorScheme.outlineVariant),
          _buildPrivacyTile(
            'Modo Privado en Comunidad',
            'Compartir hábitos de forma anónima',
            Icons.visibility_off_outlined,
            Theme.of(context).colorScheme.primary,
            _privateModeEnabled,
            (v) => setState(() => _privateModeEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTile(String title, String subtitle, IconData icon, Color iconColor, bool value, Function(bool) onChanged, {Color? subtitleDotColor}) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor.withValues(alpha: 0.1),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
                Row(
                  children: [
                    if (subtitleDotColor != null) ...[
                      Container(width: 4, height: 4, decoration: BoxDecoration(color: subtitleDotColor, shape: BoxShape.circle)),
                      SizedBox(width: 4),
                    ],
                    Expanded(child: Text(subtitle, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Theme.of(context).colorScheme.surface,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
            inactiveThumbColor: Theme.of(context).colorScheme.surface,
          )
        ],
      ),
    );
  }

  Widget _buildCoachCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHighest),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 12, color: Colors.orange.shade800),
                    SizedBox(width: 4),
                    Text('Próxima sesión', style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text('En 2 días', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                backgroundImage: AssetImage('assets/images/paisaje-dashboard.png'), // placeholder
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dra. Elena Vidal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                    Text('Especialista en hábitos - Mindfulness', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.event, color: Theme.of(context).colorScheme.primary, size: 16),
                    SizedBox(width: 8),
                    Text('Jueves, 18:00 hrs (45 min)', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('Ver enlace', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.onSurface, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Centro de Ayuda y\nPreguntas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface, height: 1.2)),
                Text('Guías rápidas, FAQs y soporte técnico', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
        ],
      ),
    );
  }
}
