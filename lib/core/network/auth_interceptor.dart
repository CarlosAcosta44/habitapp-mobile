import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  static String? _cachedToken;

  AuthInterceptor(this.secureStorage);

  static void setToken(String token) {
    _cachedToken = token;
  }

  static void clearToken() {
    _cachedToken = null;
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Read the access token from secure storage or cache
    _cachedToken ??= await secureStorage.read(key: 'access_token');
    
    if (_cachedToken != null) {
      options.headers['Authorization'] = 'Bearer $_cachedToken';
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized globally if needed
    if (err.response?.statusCode == 401) {
      _cachedToken = null;
      await secureStorage.delete(key: 'access_token');
      // En una app real aquí usaríamos un GlobalKey<NavigatorState> o Riverpod para redirigir al login
    }
    super.onError(err, handler);
  }
}
