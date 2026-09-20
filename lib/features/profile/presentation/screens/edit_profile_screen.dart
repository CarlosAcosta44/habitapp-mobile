import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/providers/biometric_provider.dart';

import '../../providers/profile_provider.dart';


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
    bool _twoFactorEnabled = false;
  
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).value;
    _nameController = TextEditingController(text: profile?.nombre ?? '');
    _lastNameController = TextEditingController(text: profile?.apellido ?? '');
    _phoneController = TextEditingController(text: profile?.telefono ?? '');
    _genderController = TextEditingController(text: profile?.genero ?? 'Femenino');
    _dobController = TextEditingController(text: profile?.fechanacimiento ?? '14 de Mayo, 1994');
    
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    
    if (pickedFile != null) {
      // Iniciar la subida de imagen
      try {
        await ref.read(profileProvider.notifier).uploadAvatar(pickedFile.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Foto de perfil actualizada correctamente.')),
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

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tomar Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Elegir de Galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
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
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perfil guardado con éxito.')),
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

  Future<void> _updatePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor llena todos los campos')));
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres')));
      return;
    }

    try {
      await ref.read(profileProvider.notifier).updatePassword(currentPassword, newPassword);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña actualizada con éxito')));
        setState(() {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
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
                  Icon(Icons.extension, color: Theme.of(context).colorScheme.primary, size: 24),
            ),
            SizedBox(width: 8),
            Text(
              'HabitApp',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
      body: profileState.when(
        data: (profile) {
          if (profile == null) return Center(child: Text('Perfil no encontrado'));
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- Avatar Section ---
                  GestureDetector(
                    onTap: _showImageSourceOptions,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                          backgroundImage: profile.fotoperfil != null ? NetworkImage(profile.fotoperfil!) : null,
                          child: profile.fotoperfil == null ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 50) : null,
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                          ),
                          child: Icon(Icons.edit, color: Theme.of(context).colorScheme.surface, size: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: _showImageSourceOptions,
                    child: Text('Cambiar foto de perfil', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  SizedBox(height: 4),
                  Text('JPG o PNG de hasta 5 MB', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11)),
                  SizedBox(height: 32),

                  // --- Información Personal ---
                  _buildSectionTitle(Icons.assignment_ind_outlined, 'Información Personal', trailingText: 'Requerido *'),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildTextField('Nombre *', _nameController, prefixIcon: Icons.person_outline)),
                            SizedBox(width: 12),
                            Expanded(child: _buildTextField('Apellido *', _lastNameController)),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildTextField('Teléfono móvil', _phoneController, suffixIcon: Icons.phone_outlined),
                        const SizedBox(height: 16),
                        _buildTextField('Fecha de nacimiento', _dobController, prefixIcon: Icons.calendar_today_outlined, suffixIcon: Icons.cake_outlined),
                        const SizedBox(height: 16),
                        _buildDropdownField('Género', _genderController, ['Masculino', 'Femenino', 'Otro', 'Prefiero no decirlo'], prefixIcon: Icons.wc_outlined),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // --- Acceso y Seguridad ---
                  _buildSectionTitle(Icons.lock_outline, 'Acceso y Seguridad'),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contraseña Expandible
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text('Cambiar Contraseña', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            leading: Icon(Icons.key_outlined, color: Theme.of(context).colorScheme.primary),
                            onExpansionChanged: (expanded) {
                            },
                            children: [
                              SizedBox(height: 8),
                              _buildTextField('Contraseña Actual', _currentPasswordController, obscureText: true),
                              SizedBox(height: 16),
                              _buildTextField('Nueva Contraseña', _newPasswordController, obscureText: true),
                              SizedBox(height: 16),
                              _buildTextField('Confirmar Nueva Contraseña', _confirmPasswordController, obscureText: true),
                              SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: _updatePassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  child: Text('Actualizar Contraseña'),
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
                        SizedBox(height: 16),

                        // Toggles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 14, backgroundColor: Color(0xFFE8F0FE), child: Icon(Icons.fingerprint, color: Theme.of(context).colorScheme.primary, size: 14)),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bloqueo biométrico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
                                    Text('Desbloquear con FaceID o huella', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                  ],
                                ),
                              ],
                            ),
                            Switch(
                              value: ref.watch(biometricProvider).value?.isEnabled ?? false,
                              onChanged: (v) async {
                                try {
                                  await ref.read(biometricProvider.notifier).toggleBiometric(v);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                                    );
                                  }
                                }
                              },
                              activeThumbColor: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 14, backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, child: Icon(Icons.shield_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 14)),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Verificación en dos pasos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
                                    Text('Código SMS o App autenticadora', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                  ],
                                ),
                              ],
                            ),
                            Switch(
                              value: _twoFactorEnabled,
                              onChanged: (v) => setState(() => _twoFactorEnabled = v),
                              activeThumbColor: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // --- Botones Inferiores ---
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _saveChanges,
                      icon: Icon(Icons.check, size: 18),
                      label: Text('Guardar Cambios', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                      child: Text('Descartar cambios', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, {String? trailingText}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        SizedBox(width: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
        Spacer(),
        if (trailingText != null)
          Text(trailingText, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {IconData? prefixIcon, IconData? suffixIcon, Widget? prefixWidget, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            prefixIcon: prefixWidget ?? (prefixIcon != null ? Icon(prefixIcon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18) : null),
            prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18) : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<String> items, {IconData? prefixIcon}) {
    // Asegurarse de que el valor inicial esté en la lista, si no, usar el primero o null
    String? currentValue = controller.text.isNotEmpty && items.contains(controller.text) ? controller.text : null;
    if (currentValue == null && controller.text.isNotEmpty) {
      currentValue = items.first; // fallback si viene algo raro
      controller.text = currentValue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: currentValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                controller.text = newValue;
              });
            }
          },
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18) : null,
            prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
          ),
        ),
      ],
    );
  }
}
