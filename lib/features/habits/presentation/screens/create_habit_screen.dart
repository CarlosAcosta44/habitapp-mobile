import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/create_habit_dto.dart';
import '../../data/models/category_model.dart';
import '../../providers/habits_provider.dart';

const _kBlue = Color(0xFF2D82FA);
const _kPink = Color(0xFFF94C84);
const _kBg = Color(0xFFF7F7F9);
const _kTextDark = Color(0xFF1E1E1E);
const _kTextGrey = Color(0xFF6B6B6B);

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
        const SnackBar(
          content: Text('Por favor completa los campos y elige al menos 1 día.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _kTextDark),
          onPressed: () => context.pop(),
        ),
        title: const Text('Crear Hábito', style: TextStyle(color: _kTextDark, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: false,
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
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No hay categorías disponibles'));
          }

          if (_selectedCategoryId == null && categories.isNotEmpty) {
            _selectedCategoryId = categories.first.id;
          }

          final selectedCat = categories.firstWhere(
            (c) => c.id == _selectedCategoryId,
            orElse: () => categories.first,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Crear Hábito', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: _kTextDark)),
                  const SizedBox(height: 16),
                  _buildCategorySelector(categories, selectedCat),
                  const SizedBox(height: 16),
                  _buildInputField('NOMBRE DEL HÁBITO', Icons.edit_note, _nombreController, 'Beber agua conscientemente'),
                  const SizedBox(height: 12),
                  _buildInputField('MOTIVACIÓN O PROPÓSITO', Icons.format_quote, _descripcionController, 'Tomar 8 vasos de agua para mantener mi energía...', maxLines: 2),
                  const SizedBox(height: 12),
                  _buildDailyGoalField(),
                  const SizedBox(height: 12),
                  _buildSoundCard(),
                  const SizedBox(height: 12),
                  _buildDaysCard(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _submitForm,
                      icon: _isLoading ? const SizedBox() : const Icon(Icons.add_task, color: Colors.white),
                      label: _isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Crear Hábito', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCategorySelector(List<CategoryModel> categories, CategoryModel selectedCat) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _kBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Icon(getCategoryIcon(selectedCat.icono), size: 32, color: _kBlue),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department, color: Color(0xFF0F8A5D), size: 12),
                    const SizedBox(width: 4),
                    Text('0d racha', style: TextStyle(color: const Color(0xFF0F8A5D), fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(selectedCat.nombre, style: const TextStyle(fontSize: 12, color: _kTextGrey)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _kBg,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: categories.map((cat) {
                final isSelected = cat.id == _selectedCategoryId;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategoryId = cat.id),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      shape: BoxShape.circle,
                      boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
                      border: isSelected ? Border.all(color: _kBlue, width: 1.5) : null,
                    ),
                    child: Icon(
                      getCategoryIcon(cat.icono),
                      size: 16,
                      color: isSelected ? _kBlue : Colors.grey.shade400,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.grey.shade400, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  maxLines: maxLines,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _kTextDark),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('META DIARIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.flag_outlined, color: Colors.grey.shade400, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _kBg,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _metaDiariaController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _kTextDark),
                          decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero, hintText: 'cantidad', hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)),
                        ),
                      ),
                      const Icon(Icons.unfold_more, color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _kBg,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _unidadMedidaController,
                          style: const TextStyle(fontSize: 12, color: _kTextDark),
                          decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero, hintText: 'unidad de medida', hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const Icon(Icons.expand_more, color: Colors.grey, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('/ dia', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSoundCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            child: const Icon(Icons.notifications_active_outlined, color: Colors.orange, size: 18),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sonido y Recordatorio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _kTextDark)),
                Text('Campana de serenidad matutina', style: TextStyle(fontSize: 11, color: _kTextGrey)),
              ],
            ),
          ),
          const Text('08:00', style: TextStyle(color: _kTextGrey, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildDaysCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Días de la semana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _kTextDark)),
              Text('${_selectedDays.length} días', style: const TextStyle(color: _kBlue, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPresetButton('Todos los\ndías', 'all', Icons.check, _selectedDays.length == 7),
              const SizedBox(width: 8),
              _buildPresetButton('Laborales\n(L-V)', 'workdays', null, _selectedDays.length == 5 && _selectedDays.containsAll([1, 2, 3, 4, 5])),
              const SizedBox(width: 8),
              _buildPresetButton('Fines de\nsemana', 'weekends', null, _selectedDays.length == 2 && _selectedDays.containsAll([6, 7])),
            ],
          ),
          const SizedBox(height: 20),
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
                    color: isSelected ? _kBlue : _kBlue.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Text(
                      day['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : _kBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFF3F3F3)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.calendar_today, color: _kBlue, size: 16),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha de inicio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _kTextDark)),
                    Text('Comenzar hoy en el calendario', style: TextStyle(fontSize: 11, color: _kTextGrey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Hoy', style: TextStyle(color: _kBlue, fontSize: 11, fontWeight: FontWeight.bold)),
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? _kBlue.withValues(alpha: 0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? _kBlue : Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && isSelected) ...[
                Icon(icon, size: 12, color: _kBlue),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? _kBlue : _kTextGrey,
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
