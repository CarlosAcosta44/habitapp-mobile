import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final void Function() onLogout;
  static String? _cachedToken;
  static String? _cachedRefreshToken;

  AuthInterceptor(this.secureStorage, this.onLogout);

  static void setToken(String token) {
    _cachedToken = token;
  }

  static void setRefreshToken(String refreshToken) {
    _cachedRefreshToken = refreshToken;
  }

  static void clearToken() {
    _cachedToken = null;
    _cachedRefreshToken = null;
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Read the access token from secure storage or cache
    _cachedToken ??= await secureStorage.read(key: 'access_token');
    
    if (_cachedToken != null) {
      options.headers['Authorization'] = 'Bearer $_cachedToken';
    }
    
    // Set Timezone Offset for accurate daily streak tracking
    options.headers['X-Timezone-Offset'] = DateTime.now().timeZoneOffset.inMinutes.toString();
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Si recibimos 401 y tenemos un refresh token, intentamos renovar
    if (err.response?.statusCode == 401) {
      _cachedRefreshToken ??= await secureStorage.read(key: 'refresh_token');

      if (_cachedRefreshToken != null) {
        try {
          // Usamos una instancia nueva de Dio para evitar loops infinitos con el interceptor
          final refreshDio = Dio(BaseOptions(
            baseUrl: err.requestOptions.baseUrl,
            headers: {'Content-Type': 'application/json'},
          ));

          final response = await refreshDio.post('/auth/refresh', data: {
            'refresh_token': _cachedRefreshToken,
          });

          final newAccessToken = response.data['access_token'];
          final newRefreshToken = response.data['refresh_token'];

          if (newAccessToken != null) {
            // Actualizar caché y storage
            setToken(newAccessToken);
            if (newRefreshToken != null) {
              setRefreshToken(newRefreshToken);
              await secureStorage.write(key: 'refresh_token', value: newRefreshToken);
            }
            await secureStorage.write(key: 'access_token', value: newAccessToken);

            // Reintentar la petición original con el nuevo token
            final originalOptions = err.requestOptions;
            originalOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            
            final retryDio = Dio(BaseOptions(baseUrl: originalOptions.baseUrl));
            final retryResponse = await retryDio.fetch(originalOptions);
            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // Si el refresh falla (ej. token revocado o expirado), fallamos y forzamos logout
        }
      }

      // Si no pudimos refrescar, cerramos sesión
      _cachedToken = null;
      _cachedRefreshToken = null;
      await secureStorage.delete(key: 'access_token');
      await secureStorage.delete(key: 'refresh_token');
      
      // Llamamos el callback de logout sin depender de Riverpod
      onLogout();
    }
    super.onError(err, handler);
  }
}
