// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotes_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quotesService)
final quotesServiceProvider = QuotesServiceProvider._();

final class QuotesServiceProvider
    extends $FunctionalProvider<QuotesService, QuotesService, QuotesService>
    with $Provider<QuotesService> {
  QuotesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quotesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quotesServiceHash();

  @$internal
  @override
  $ProviderElement<QuotesService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuotesService create(Ref ref) {
    return quotesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuotesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuotesService>(value),
    );
  }
}

String _$quotesServiceHash() => r'cd82c6a02e97a6048f1f5a05471f192868a7f7ec';
