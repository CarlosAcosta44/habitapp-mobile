import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_interceptor.dart';

part 'dio_client.g.dart';

// Provider for FlutterSecureStorage
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

// Provider for Dio client
@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'http://localhost:4000/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add the Auth Interceptor
  dio.interceptors.add(AuthInterceptor(secureStorage, ref));
  
  // Add a simple log interceptor for debugging
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return dio;
}
