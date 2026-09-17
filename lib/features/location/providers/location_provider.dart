import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/services/location_service.dart';

part 'location_provider.g.dart';

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  return LocationService();
}

@Riverpod(keepAlive: true)
class UserLocationNotifier extends _$UserLocationNotifier {
  @override
  Future<Position?> build() async {
    final service = ref.watch(locationServiceProvider);
    return service.getCurrentPosition();
  }

  /// Solicita y refresca la posición geográfica del usuario
  Future<Position?> refreshLocation() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(locationServiceProvider);
      final pos = await service.getCurrentPosition();
      state = AsyncValue.data(pos);
      return pos;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
