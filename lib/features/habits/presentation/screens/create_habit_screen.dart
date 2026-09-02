import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/create_habit_dto.dart';
import '../../providers/habits_provider.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _metaDiariaController = TextEditingController(text: '1');
  final _unidadMedidaController = TextEditingController(text: 'veces');

  String? _selectedCategoryId;
  double _puntos = 10;
  DateTime _fechaInicio = DateTime.now();
  DateTime? _fechaFin;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _metaDiariaController.dispose();
    _unidadMedidaController.dispose();
    super.dispose();
  }

  Future<void> _selectFechaInicio(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _fechaInicio = picked;
      });
    }
  }

  Future<void> _selectFechaFin(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaFin ?? _fechaInicio.add(const Duration(days: 30)),
      firstDate: _fechaInicio,
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _fechaFin = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una categoría'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final dto = CreateHabitDto(
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim().isEmpty
          ? null
          : _descripcionController.text.trim(),
      fechaInicio: _formatDate(_fechaInicio),
      fechaFin: _fechaFin != null ? _formatDate(_fechaFin!) : null,
      puntos: _puntos.round(),
      metaDiaria: double.tryParse(_metaDiariaController.text.trim()) ?? 1.0,
      unidadMedida: _unidadMedidaController.text.trim().isEmpty
          ? 'veces'
          : _unidadMedidaController.text.trim(),
      idCategoria: _selectedCategoryId!,
    );

    final success = await ref
        .read(habitsDashboardProvider.notifier)
        .createHabit(dto);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Hábito creado exitosamente! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al crear el hábito. Inténtalo de nuevo.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear Nuevo Hábito',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header banner
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor.withValues(alpha: 0.8),
                        theme.colorScheme.secondary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Diseña tu nuevo hábito para alcanzar tus metas diarias.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Nombre del hábito
                Text(
                  'Nombre del Hábito',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    hintText: 'Ej. Beber 2L de agua, Correr, Leer 10 págs',
                    prefixIcon: const Icon(Icons.edit_calendar),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa un nombre para el hábito';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Descripción
                Text(
                  'Descripción (Opcional)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descripcionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Añade una breve nota o motivo...',
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Categoría
                Text(
                  'Categoría',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                categoriesAsync.when(
                  data: (categories) {
                    if (categories.isEmpty) {
                      return const Text('No hay categorías disponibles');
                    }
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedCategoryId,
                      hint: const Text('Selecciona una categoría'),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.id,
                          child: Text(cat.nombre),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategoryId = val;
                        });
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, _) => Text(
                    'Error al cargar categorías: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 20),

                // Meta diaria y Unidad de medida
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meta Diaria',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _metaDiariaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.numbers),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Requerido';
                              }
                              if (double.tryParse(val) == null) {
                                return 'Inválido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unidad de Medida',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _unidadMedidaController,
                            decoration: InputDecoration(
                              hintText: 'veces, ml, km, págs',
                              prefixIcon: const Icon(Icons.square_foot),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Puntos otorgados
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Puntos al completar',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
                      label: Text(
                        '${_puntos.round()} pts',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _puntos,
                  min: 1,
                  max: 100,
                  divisions: 99,
                  label: '${_puntos.round()} pts',
                  onChanged: (val) {
                    setState(() {
                      _puntos = val;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Fechas (Inicio / Fin)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectFechaInicio(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text('Inicio: ${_formatDate(_fechaInicio)}'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectFechaFin(context),
                        icon: const Icon(Icons.event),
                        label: Text(_fechaFin == null
                            ? 'Fin: Opcional'
                            : 'Fin: ${_formatDate(_fechaFin!)}'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Botón Guardar
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Guardar Hábito',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
