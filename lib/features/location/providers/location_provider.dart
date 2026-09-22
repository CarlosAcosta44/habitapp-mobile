import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/location_repository.dart';

part 'location_provider.g.dart';

@Riverpod(keepAlive: true)
LocationRepository locationRepository(Ref ref) {
  return LocationRepository();
}

@Riverpod(keepAlive: true)
class UserLocationNotifier extends _$UserLocationNotifier {
  @override
  Future<(Position, String)?> build() async {
    return _fetchLocation();
  }

  Future<(Position, String)?> _fetchLocation() async {
    final repository = ref.read(locationRepositoryProvider);
    final pos = await repository.getCurrentPosition();
    if (pos == null) return null;

    try {
      final geocoding = Geocoding();
      final placemarks = await geocoding.placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = '${place.locality}, ${place.country}';
        return (pos, address);
      }
    } catch (e) {
      // Ignorar error de geocoding, retornar coordenadas
    }
    
    return (pos, 'Lat: ${pos.latitude.toStringAsFixed(4)}, Lng: ${pos.longitude.toStringAsFixed(4)}');
  }

  Future<(Position, String)?> refreshLocation() async {
    state = const AsyncValue.loading();
    try {
      final result = await _fetchLocation();
      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
