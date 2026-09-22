// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_routine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(availableClients)
final availableClientsProvider = AvailableClientsProvider._();

final class AvailableClientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ClientSummary>>,
          List<ClientSummary>,
          FutureOr<List<ClientSummary>>
        >
    with
        $FutureModifier<List<ClientSummary>>,
        $FutureProvider<List<ClientSummary>> {
  AvailableClientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableClientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableClientsHash();

  @$internal
  @override
  $FutureProviderElement<List<ClientSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClientSummary>> create(Ref ref) {
    return availableClients(ref);
  }
}

String _$availableClientsHash() => r'725d863776ade4a018c21e5e454b8a4a839d181c';

@ProviderFor(availableRoutines)
final availableRoutinesProvider = AvailableRoutinesProvider._();

final class AvailableRoutinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoutineSummary>>,
          List<RoutineSummary>,
          FutureOr<List<RoutineSummary>>
        >
    with
        $FutureModifier<List<RoutineSummary>>,
        $FutureProvider<List<RoutineSummary>> {
  AvailableRoutinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableRoutinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableRoutinesHash();

  @$internal
  @override
  $FutureProviderElement<List<RoutineSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RoutineSummary>> create(Ref ref) {
    return availableRoutines(ref);
  }
}

String _$availableRoutinesHash() => r'0af23c1cec4567c8f3e9a40c6b511d8c1b7ca030';

@ProviderFor(AssignRoutineController)
final assignRoutineControllerProvider = AssignRoutineControllerProvider._();

final class AssignRoutineControllerProvider
    extends $AsyncNotifierProvider<AssignRoutineController, void> {
  AssignRoutineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assignRoutineControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assignRoutineControllerHash();

  @$internal
  @override
  AssignRoutineController create() => AssignRoutineController();
}

String _$assignRoutineControllerHash() =>
    r'190d26839cfc0c059a9c7254b6e55cc0d064dc36';

abstract class _$AssignRoutineController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
