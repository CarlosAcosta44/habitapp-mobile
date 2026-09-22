import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'auth_interceptor.dart';

part 'dio_client.g.dart';

// Provider for FlutterSecureStorage
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return FlutterSecureStorage();
}

// Provider for Dio client
@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://habitapp-api-hnbba0c8cqfvc2hj.chilecentral-01.azurewebsites.net/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add the Auth Interceptor — passes a callback instead of ref to avoid
  // a circular dependency: dioClient -> AuthInterceptor(ref) -> authProvider -> authRepository -> dioClient
  dio.interceptors.add(AuthInterceptor(secureStorage, () {
    // Read authProvider lazily only when a real 401 occurs, not during build
    ref.read(authProvider.notifier).logout();
  }));
  
  // Add a simple log interceptor for debugging
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return dio;
}
