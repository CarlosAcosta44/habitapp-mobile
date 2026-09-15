import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../providers/profile_provider.dart';

const _kBlue = Color(0xFF2D82FA);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);
const _kBg = Color(0xFFF3F4F6);
const _kFieldBg = Color(0xFFF3F4F6); // actually the form background is white, fields are grey
const _kBorder = Color(0xFFE5E7EB);

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;
  late TextEditingController _dobController;
  late TextEditingController _timezoneController;
  
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).value;
    _nameController = TextEditingController(text: profile?.nombre ?? '');
    _lastNameController = TextEditingController(text: profile?.apellido ?? '');
    _phoneController = TextEditingController(text: profile?.telefono ?? '');
    _genderController = TextEditingController(text: profile?.genero ?? 'Femenino');
    _dobController = TextEditingController(text: profile?.fechanacimiento ?? '14 de Mayo, 1994');
    _timezoneController = TextEditingController(text: profile?.zonaHoraria ?? 'UTC -5 (Bogotá, Lima, Quito)');
    
    // Autodetectar zona horaria si está vacía
    if (profile != null && (profile.zonaHoraria == null || profile.zonaHoraria!.isEmpty)) {
      _loadTimezone();
    }
  }

  Future<void> _loadTimezone() async {
    try {
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      if (mounted) {
        setState(() {
          _timezoneController.text = currentTimeZone.identifier;
        });
      }
    } catch (e) {
      // Ignore timezone fetch error
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    
    if (pickedFile != null) {
      // Iniciar la subida de imagen
      try {
        await ref.read(profileProvider.notifier).uploadAvatar(pickedFile.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto de perfil actualizada correctamente.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir imagen: $e')),
          );
        }
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(profileProvider.notifier).updateProfile({
          'nombre': _nameController.text,
          'apellido': _lastNameController.text,
          'telefono': _phoneController.text,
          'genero': _genderController.text,
          'fechanacimiento': _dobController.text,
          'zona_horaria': _timezoneController.text,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil guardado con éxito.')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kTextDark),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-habitapp.png',
              width: 24,
              height: 24,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.extension, color: _kBlue, size: 24),
            ),
            const SizedBox(width: 8),
            const Text(
              'HabitApp',
              style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
      body: profileState.when(
        data: (profile) {
          if (profile == null) return const Center(child: Text('Perfil no encontrado'));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- Avatar Section ---
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: profile.fotoperfil != null ? NetworkImage(profile.fotoperfil!) : null,
                          child: profile.fotoperfil == null ? const Icon(Icons.person, color: Colors.grey, size: 50) : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _kBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: _kBg, width: 3),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickImage,
                    child: const Text('Cambiar foto de perfil', style: TextStyle(color: _kBlue, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  const SizedBox(height: 4),
                  const Text('JPG o PNG de hasta 5 MB', style: TextStyle(color: _kTextGrey, fontSize: 11)),
                  const SizedBox(height: 32),

                  // --- Información Personal ---
                  _buildSectionTitle(Icons.assignment_ind_outlined, 'Información Personal', trailingText: 'Requerido *'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _kBorder),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildTextField('Nombre *', _nameController, prefixIcon: Icons.person_outline)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildTextField('Apellido *', _lastNameController)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField('Teléfono móvil', _phoneController, suffixIcon: Icons.phone_outlined),
                        const SizedBox(height: 16),
                        _buildTextField('Género', _genderController, prefixIcon: Icons.people_outline, suffixIcon: Icons.expand_more),
                        const SizedBox(height: 16),
                        _buildTextField('Fecha de nacimiento', _dobController, prefixIcon: Icons.calendar_today_outlined, suffixIcon: Icons.cake_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- Preferencias ---
                  _buildSectionTitle(Icons.settings_outlined, 'Preferencias'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _kBorder),
                    ),
                    child: Column(
                      children: [
                        _buildTextField('Zona Horaria', _timezoneController, prefixIcon: Icons.language_outlined, suffixIcon: Icons.expand_more),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- Acceso y Seguridad ---
                  _buildSectionTitle(Icons.lock_outline, 'Acceso y Seguridad'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _kBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Correo Electrónico', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _kTextGrey)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: _kBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                              child: const Row(
                                children: [
                                  Icon(Icons.verified, color: _kBlue, size: 12),
                                  SizedBox(width: 4),
                                  Text('Verificado', style: TextStyle(color: _kBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(color: _kFieldBg, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.mail_outline, color: _kTextGrey, size: 18),
                              const SizedBox(width: 12),
                              Text(profile.correo ?? '${profile.idusuario.substring(0, 6)}@ejemplo.com', style: const TextStyle(color: _kTextDark, fontSize: 14)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(border: Border.all(color: _kBorder), borderRadius: BorderRadius.circular(8), color: Colors.white),
                                child: const Text('Modificar', style: TextStyle(color: _kBlue, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Contraseña
                        const Text('Contraseña', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _kTextGrey)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(color: _kFieldBg, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.key_outlined, color: _kTextGrey, size: 18),
                              const SizedBox(width: 12),
                              const Text('••••••••••••', style: TextStyle(color: _kTextDark, fontSize: 14, letterSpacing: 2)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(border: Border.all(color: _kBorder), borderRadius: BorderRadius.circular(8), color: Colors.white),
                                child: const Text('Actualizar', style: TextStyle(color: _kBlue, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: _kBorder),
                        const SizedBox(height: 16),

                        // Toggles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(radius: 14, backgroundColor: Color(0xFFE8F0FE), child: Icon(Icons.fingerprint, color: _kBlue, size: 14)),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bloqueo biométrico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _kTextDark)),
                                    Text('Desbloquear con FaceID o huella', style: TextStyle(fontSize: 10, color: _kTextGrey)),
                                  ],
                                ),
                              ],
                            ),
                            Switch(
                              value: _biometricEnabled,
                              onChanged: (v) => setState(() => _biometricEnabled = v),
                              activeThumbColor: _kBlue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(radius: 14, backgroundColor: _kFieldBg, child: Icon(Icons.shield_outlined, color: _kTextGrey, size: 14)),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Verificación en dos pasos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _kTextDark)),
                                    Text('Código SMS o App autenticadora', style: TextStyle(fontSize: 10, color: _kTextGrey)),
                                  ],
                                ),
                              ],
                            ),
                            Switch(
                              value: _twoFactorEnabled,
                              onChanged: (v) => setState(() => _twoFactorEnabled = v),
                              activeThumbColor: _kBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- Botones Inferiores ---
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Guardar Cambios', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        backgroundColor: _kBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _kBorder),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text('Descartar cambios', style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, {String? trailingText}) {
    return Row(
      children: [
        Icon(icon, color: _kBlue, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _kTextDark)),
        const Spacer(),
        if (trailingText != null)
          Text(trailingText, style: const TextStyle(fontSize: 11, color: _kTextGrey)),
      ],
    );
  }



  Widget _buildTextField(String label, TextEditingController controller, {IconData? prefixIcon, IconData? suffixIcon, Widget? prefixWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _kTextGrey)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _kTextDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: _kFieldBg,
            prefixIcon: prefixWidget ?? (prefixIcon != null ? Icon(prefixIcon, color: _kTextGrey, size: 18) : null),
            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: _kTextGrey, size: 18) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _kBlue)),
          ),
        ),
      ],
    );
  }
}
