import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/create_habit_dto.dart';
import '../../data/models/category_model.dart';
import '../../providers/habits_provider.dart';


IconData getCategoryIcon(String? iconName) {
  switch (iconName?.toLowerCase()) {
    case 'water_drop':
    case 'agua':
      return Icons.water_drop_outlined;
    case 'fitness_center':
    case 'deporte':
      return Icons.fitness_center;
    case 'self_improvement':
    case 'mindfulness':
    case 'mente':
      return Icons.self_improvement;
    case 'bedtime':
    case 'descanso':
      return Icons.bedtime_outlined;
    case 'restaurant':
    case 'nutricion':
      return Icons.restaurant_outlined;
    case 'checklist':
      return Icons.checklist_rtl_outlined;
    case 'salud':
      return Icons.favorite_outline;
    case 'lectura':
      return Icons.menu_book;
    default:
      return Icons.category_outlined;
  }
}

class CreateHabitScreen extends ConsumerStatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _metaDiariaController = TextEditingController();
  final _unidadMedidaController = TextEditingController();

  String? _selectedCategoryId;
  final DateTime _fechaInicio = DateTime.now();
  DateTime? _fechaFin;
  bool _isLoading = false;

  final Set<int> _selectedDays = {1, 2, 3, 4, 5, 6, 7};

  final List<Map<String, dynamic>> _dayList = [
    {'id': 1, 'label': 'L'},
    {'id': 2, 'label': 'M'},
    {'id': 3, 'label': 'M'},
    {'id': 4, 'label': 'J'},
    {'id': 5, 'label': 'V'},
    {'id': 6, 'label': 'S'},
    {'id': 7, 'label': 'D'},
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _metaDiariaController.dispose();
    _unidadMedidaController.dispose();
    super.dispose();
  }

  void _toggleDay(int dayId) {
    setState(() {
      if (_selectedDays.contains(dayId)) {
        _selectedDays.remove(dayId);
      } else {
        _selectedDays.add(dayId);
      }
    });
  }

  void _selectPreset(String preset) {
    setState(() {
      _selectedDays.clear();
      switch (preset) {
        case 'all':
          _selectedDays.addAll([1, 2, 3, 4, 5, 6, 7]);
          break;
        case 'workdays':
          _selectedDays.addAll([1, 2, 3, 4, 5]);
          break;
        case 'weekends':
          _selectedDays.addAll([6, 7]);
          break;
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _submitForm() async {
    final isFormValid = _formKey.currentState!.validate();

    if (!isFormValid || _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa los campos y elige al menos 1 día.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor selecciona una categoría'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final sortedDays = _selectedDays.toList()..sort();

    final dto = CreateHabitDto(
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim().isEmpty ? null : _descripcionController.text.trim(),
      fechaInicio: _formatDate(_fechaInicio),
      fechaFin: _fechaFin != null ? _formatDate(_fechaFin!) : null,
      puntos: 10,
      metaDiaria: double.tryParse(_metaDiariaController.text.trim()) ?? 1.0,
      unidadMedida: _unidadMedidaController.text.trim().isEmpty ? 'veces' : _unidadMedidaController.text.trim(),
      idCategoria: _selectedCategoryId!,
      diasSemana: sortedDays,
    );

    final success = await ref.read(habitsDashboardProvider.notifier).createHabit(dto);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text('Crear Hábito', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              child: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.secondary, size: 18),
            ),
          )
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(child: Text('No hay categorías disponibles'));
          }

          if (_selectedCategoryId == null && categories.isNotEmpty) {
            _selectedCategoryId = categories.first.id;
          }

          final selectedCat = categories.firstWhere(
            (c) => c.id == _selectedCategoryId,
            orElse: () => categories.first,
          );

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Crear Hábito', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 16),
                  _buildCategorySelector(categories, selectedCat),
                  SizedBox(height: 16),
                  _buildInputField('NOMBRE DEL HÁBITO', Icons.edit_note, _nombreController, 'Beber agua conscientemente'),
                  SizedBox(height: 12),
                  _buildInputField('MOTIVACIÓN O PROPÓSITO', Icons.format_quote, _descripcionController, 'Tomar 8 vasos de agua para mantener mi energía...', maxLines: 2),
                  SizedBox(height: 12),
                  _buildDailyGoalField(),
                  SizedBox(height: 12),
                  _buildSoundCard(),
                  SizedBox(height: 12),
                  _buildDaysCard(),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _submitForm,
                      icon: _isLoading ? SizedBox() : Icon(Icons.add_task, color: Theme.of(context).colorScheme.surface),
                      label: _isLoading
                          ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.surface, strokeWidth: 2))
                          : Text('Crear Hábito', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCategorySelector(List<CategoryModel> categories, CategoryModel selectedCat) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Icon(getCategoryIcon(selectedCat.icono), size: 32, color: Theme.of(context).colorScheme.primary),
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, color: Color(0xFF0F8A5D), size: 12),
                    SizedBox(width: 4),
                    Text('0d racha', style: TextStyle(color: Color(0xFF0F8A5D), fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(selectedCat.nombre, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: categories.map((cat) {
                final isSelected = cat.id == _selectedCategoryId;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategoryId = cat.id),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      shape: BoxShape.circle,
                      boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: Offset(0, 2))] : [],
                      border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5) : null,
                    ),
                    child: Icon(
                      getCategoryIcon(cat.icono),
                      size: 16,
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.grey.shade400, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Requerido';
                    return null;
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDailyGoalField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('META DIARIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.flag_outlined, color: Colors.grey.shade400, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _metaDiariaController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          decoration: InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero, hintText: 'cantidad', hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)),
                        ),
                      ),
                      Icon(Icons.unfold_more, color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _unidadMedidaController,
                          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                          decoration: InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero, hintText: 'unidad de medida', hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Icon(Icons.expand_more, color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text('/ dia', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSoundCard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            child: Icon(Icons.notifications_active_outlined, color: Colors.orange, size: 18),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sonido y Recordatorio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
                Text('Campana de serenidad matutina', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text('08:00', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold, fontSize: 12)),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildDaysCard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Días de la semana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
              Text('${_selectedDays.length} días', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildPresetButton('Todos los\ndías', 'all', Icons.check, _selectedDays.length == 7),
              SizedBox(width: 8),
              _buildPresetButton('Laborales\n(L-V)', 'workdays', null, _selectedDays.length == 5 && _selectedDays.containsAll([1, 2, 3, 4, 5])),
              SizedBox(width: 8),
              _buildPresetButton('Fines de\nsemana', 'weekends', null, _selectedDays.length == 2 && _selectedDays.containsAll([6, 7])),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _dayList.map((day) {
              final isSelected = _selectedDays.contains(day['id']);
              return GestureDetector(
                onTap: () => _toggleDay(day['id'] as int),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Text(
                      day['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 24),
          Divider(height: 1, color: Color(0xFFF3F3F3)),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary, size: 16),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha de inicio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
                    Text('Comenzar hoy en el calendario', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Hoy', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPresetButton(String text, String preset, IconData? icon, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectPreset(preset),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && isSelected) ...[
                Icon(icon, size: 12, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: 4),
              ],
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
