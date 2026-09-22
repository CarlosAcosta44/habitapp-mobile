// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ForumsNotifier)
final forumsProvider = ForumsNotifierProvider._();

final class ForumsNotifierProvider
    extends $AsyncNotifierProvider<ForumsNotifier, List<dynamic>> {
  ForumsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forumsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forumsNotifierHash();

  @$internal
  @override
  ForumsNotifier create() => ForumsNotifier();
}

String _$forumsNotifierHash() => r'7659636218daa9b9dcc632555c560832d2089437';

abstract class _$ForumsNotifier extends $AsyncNotifier<List<dynamic>> {
  FutureOr<List<dynamic>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<dynamic>>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<dynamic>>, List<dynamic>>,
              AsyncValue<List<dynamic>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ForumCommentsNotifier)
final forumCommentsProvider = ForumCommentsNotifierFamily._();

final class ForumCommentsNotifierProvider
    extends $AsyncNotifierProvider<ForumCommentsNotifier, List<dynamic>> {
  ForumCommentsNotifierProvider._({
    required ForumCommentsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'forumCommentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$forumCommentsNotifierHash();

  @override
  String toString() {
    return r'forumCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ForumCommentsNotifier create() => ForumCommentsNotifier();

  @override
  bool operator ==(Object other) {
    return other is ForumCommentsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$forumCommentsNotifierHash() =>
    r'c3bf701e338103030654e8f93294824e68813614';

final class ForumCommentsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ForumCommentsNotifier,
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          FutureOr<List<dynamic>>,
          String
        > {
  ForumCommentsNotifierFamily._()
    : super(
        retry: null,
        name: r'forumCommentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ForumCommentsNotifierProvider call(String forumId) =>
      ForumCommentsNotifierProvider._(argument: forumId, from: this);

  @override
  String toString() => r'forumCommentsProvider';
}

abstract class _$ForumCommentsNotifier extends $AsyncNotifier<List<dynamic>> {
  late final _$args = ref.$arg as String;
  String get forumId => _$args;

  FutureOr<List<dynamic>> build(String forumId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<dynamic>>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<dynamic>>, List<dynamic>>,
              AsyncValue<List<dynamic>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(RetosNotifier)
final retosProvider = RetosNotifierProvider._();

final class RetosNotifierProvider
    extends $AsyncNotifierProvider<RetosNotifier, List<dynamic>> {
  RetosNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'retosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$retosNotifierHash();

  @$internal
  @override
  RetosNotifier create() => RetosNotifier();
}

String _$retosNotifierHash() => r'06b3da7dd200baeae74002321b53f13d550e93dc';

abstract class _$RetosNotifier extends $AsyncNotifier<List<dynamic>> {
  FutureOr<List<dynamic>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<dynamic>>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<dynamic>>, List<dynamic>>,
              AsyncValue<List<dynamic>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(especialistas)
final especialistasProvider = EspecialistasProvider._();

final class EspecialistasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          FutureOr<List<dynamic>>
        >
    with $FutureModifier<List<dynamic>>, $FutureProvider<List<dynamic>> {
  EspecialistasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'especialistasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$especialistasHash();

  @$internal
  @override
  $FutureProviderElement<List<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<dynamic>> create(Ref ref) {
    return especialistas(ref);
  }
}

String _$especialistasHash() => r'59a997883762174c1f5c935ae65fa29c1977d4f6';

@ProviderFor(articulos)
final articulosProvider = ArticulosProvider._();

final class ArticulosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          FutureOr<List<dynamic>>
        >
    with $FutureModifier<List<dynamic>>, $FutureProvider<List<dynamic>> {
  ArticulosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'articulosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$articulosHash();

  @$internal
  @override
  $FutureProviderElement<List<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<dynamic>> create(Ref ref) {
    return articulos(ref);
  }
}

String _$articulosHash() => r'75ba8375e6f3959474fbc77341f57b776855701e';

@ProviderFor(CommunityHabitsNotifier)
final communityHabitsProvider = CommunityHabitsNotifierProvider._();

final class CommunityHabitsNotifierProvider
    extends $AsyncNotifierProvider<CommunityHabitsNotifier, List<dynamic>> {
  CommunityHabitsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communityHabitsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communityHabitsNotifierHash();

  @$internal
  @override
  CommunityHabitsNotifier create() => CommunityHabitsNotifier();
}

String _$communityHabitsNotifierHash() =>
    r'084731b07e582616a1551f9d5c6c4e02516eb202';

abstract class _$CommunityHabitsNotifier extends $AsyncNotifier<List<dynamic>> {
  FutureOr<List<dynamic>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<dynamic>>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<dynamic>>, List<dynamic>>,
              AsyncValue<List<dynamic>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ReactionNotifier)
final reactionProvider = ReactionNotifierProvider._();

final class ReactionNotifierProvider
    extends $AsyncNotifierProvider<ReactionNotifier, void> {
  ReactionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reactionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reactionNotifierHash();

  @$internal
  @override
  ReactionNotifier create() => ReactionNotifier();
}

String _$reactionNotifierHash() => r'5f0abf5e22cf441622ff3364f3a363c4b4758641';

abstract class _$ReactionNotifier extends $AsyncNotifier<void> {
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
