import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/assign_routine_controller.dart';
import '../../domain/client_summary.dart';
import '../../domain/routine_summary.dart';

class AssignRoutineBottomSheet extends ConsumerStatefulWidget {
  const AssignRoutineBottomSheet({super.key});

  @override
  ConsumerState<AssignRoutineBottomSheet> createState() => _AssignRoutineBottomSheetState();
}

class _AssignRoutineBottomSheetState extends ConsumerState<AssignRoutineBottomSheet> {
  ClientSummary? selectedClient;
  RoutineSummary? selectedRoutine;

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(availableClientsProvider);
    final routinesAsync = ref.watch(availableRoutinesProvider);
    final assignState = ref.watch(assignRoutineControllerProvider);

    final isLoading = assignState.isLoading;

    ref.listen<AsyncValue<void>>(assignRoutineControllerProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      } else if (next.hasValue && prev?.isLoading == true) {
        Navigator.of(context).pop(true);
      }
    });

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Asignar Rutina a Cliente',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          clientsAsync.when(
            data: (clients) => DropdownButtonFormField<ClientSummary>(
              decoration: InputDecoration(
                labelText: 'Seleccionar Cliente', 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              initialValue: selectedClient,
              items: clients.map((c) => DropdownMenuItem(value: c, child: Text(c.fullName))).toList(),
              onChanged: isLoading ? null : (v) => setState(() => selectedClient = v),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Error cargando clientes: $e'),
          ),
          const SizedBox(height: 16),
          routinesAsync.when(
            data: (routines) => DropdownButtonFormField<RoutineSummary>(
              decoration: InputDecoration(
                labelText: 'Seleccionar Rutina', 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              initialValue: selectedRoutine,
              items: routines.map((r) => DropdownMenuItem(value: r, child: Text(r.title))).toList(),
              onChanged: isLoading ? null : (v) => setState(() => selectedRoutine = v),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('Error cargando rutinas: $e'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: (selectedClient == null || selectedRoutine == null || isLoading)
                ? null
                : () {
                    ref.read(assignRoutineControllerProvider.notifier).assign(
                          clientId: selectedClient!.id,
                          routineId: selectedRoutine!.id,
                        );
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Confirmar Asignación', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
