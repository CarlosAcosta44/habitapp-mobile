import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/providers/auth_provider.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final Ref ref;
  static String? _cachedToken;

  AuthInterceptor(this.secureStorage, this.ref);

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
      ref.read(authProvider.notifier).logout();
    }
    super.onError(err, handler);
  }
}
