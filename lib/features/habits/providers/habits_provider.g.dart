// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryModel>>,
          List<CategoryModel>,
          FutureOr<List<CategoryModel>>
        >
    with
        $FutureModifier<List<CategoryModel>>,
        $FutureProvider<List<CategoryModel>> {
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<CategoryModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryModel>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'271e6eaa8998a15055bb118eb45409ad8de15f90';

@ProviderFor(HabitsDashboardNotifier)
final habitsDashboardProvider = HabitsDashboardNotifierProvider._();

final class HabitsDashboardNotifierProvider
    extends $AsyncNotifierProvider<HabitsDashboardNotifier, List<HabitModel>> {
  HabitsDashboardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'habitsDashboardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$habitsDashboardNotifierHash();

  @$internal
  @override
  HabitsDashboardNotifier create() => HabitsDashboardNotifier();
}

String _$habitsDashboardNotifierHash() =>
    r'af65c925893cbea4e49cd6ba9d9dda12b30855f3';

abstract class _$HabitsDashboardNotifier
    extends $AsyncNotifier<List<HabitModel>> {
  FutureOr<List<HabitModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<HabitModel>>, List<HabitModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<HabitModel>>, List<HabitModel>>,
              AsyncValue<List<HabitModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
