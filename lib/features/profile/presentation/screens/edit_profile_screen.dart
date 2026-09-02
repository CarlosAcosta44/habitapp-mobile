import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _telefonoController;
  
  String? _generoSeleccionado;
  String? _zonaHorariaSeleccionada;
  
  final List<String> _zonasHorarias = [
    'America/Bogota',
    'America/Mexico_City',
    'America/Argentina/Buenos_Aires',
    'America/Santiago',
    'America/Lima',
    'Europe/Madrid',
  ];
  
  final List<String> _generos = ['Masculino', 'Femenino', 'Otro'];

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _apellidoController = TextEditingController();
    _telefonoController = TextEditingController();

    // Inicializar valores cuando el build haya terminado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(profileProvider);
      profileState.whenData((profile) {
        if (profile != null) {
          setState(() {
            _nombreController.text = profile.nombre;
            _apellidoController.text = profile.apellido;
            _telefonoController.text = profile.telefono ?? '';
            _generoSeleccionado = profile.genero;
            
            // Asignar zona horaria por defecto si no existe (la API no la trae aún, pero se envía)
            _zonaHorariaSeleccionada = 'America/Bogota';
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _guardarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'nombre': _nombreController.text,
      'apellido': _apellidoController.text,
      'telefono': _telefonoController.text,
      'genero': _generoSeleccionado,
      'zona_horaria': _zonaHorariaSeleccionada, // Campo adicional requerido por diseño
    };

    try {
      await ref.read(profileProvider.notifier).updateProfile(data);
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil actualizado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar el perfil: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Avatar Placeholder
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: profileState.value?.fotoperfil != null
                                ? NetworkImage(profileState.value!.fotoperfil!)
                                : null,
                            child: profileState.value?.fotoperfil == null
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                onPressed: () {
                                  // TODO: Implementar subida de foto de perfil
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Funcionalidad de foto en construcción')),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _apellidoController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Género',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _generoSeleccionado,
                      items: _generos.map((String genero) {
                        return DropdownMenuItem<String>(
                          value: genero,
                          child: Text(genero),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _generoSeleccionado = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Zona Horaria',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _zonaHorariaSeleccionada,
                      items: _zonasHorarias.map((String zona) {
                        return DropdownMenuItem<String>(
                          value: zona,
                          child: Text(zona),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _zonaHorariaSeleccionada = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    ElevatedButton(
                      onPressed: _guardarPerfil,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Guardar Cambios'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
