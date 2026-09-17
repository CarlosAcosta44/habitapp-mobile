import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Verifica si los servicios de geolocalización (GPS) están encendidos en el dispositivo
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('Error comprobando estado de GPS: $e');
      return false;
    }
  }

  /// Solicita permisos de ubicación de forma segura sin bloquear el flujo de la app
  Future<bool> requestPermission() async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Servicio de ubicación deshabilitado.');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Permiso de ubicación denegado por el usuario.');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Permisos de ubicación denegados permanentemente.');
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      debugPrint('Error al solicitar permisos de ubicación: $e');
      return false;
    }
  }

  /// Obtiene la posición geográfica actual (Latitud y Longitud).
  /// Si el permiso es denegado o el servicio está desactivado, retorna `null` limpiamente.
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      debugPrint('Excepción obteniendo posición actual: $e');
      return null;
    }
  }
}
