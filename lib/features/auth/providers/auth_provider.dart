import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../core/network/auth_interceptor.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late FlutterSecureStorage _storage;
  late AuthRepository _repository;

  @override
  Future<bool> build() async {
    _storage = ref.watch(secureStorageProvider);
    _repository = ref.watch(authRepositoryProvider);
    return _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = AsyncValue.loading();
    try {
      final response = await _repository.login(email, password);
      final token = response['access_token'];
      if (token != null) {
        AuthInterceptor.setToken(token);
        await _storage.write(key: 'access_token', value: token);
        state = AsyncValue.data(true);
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password, String nombre, String apellido) async {
    state = AsyncValue.loading();
    try {
      final response = await _repository.register(email, password, nombre, apellido);
      final token = response['access_token'];
      if (token != null) {
        AuthInterceptor.setToken(token);
        await _storage.write(key: 'access_token', value: token);
        state = AsyncValue.data(true);
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    AuthInterceptor.clearToken();
    await _storage.delete(key: 'access_token');
    state = AsyncValue.data(false);
  }

  // --- SOCIAL LOGIN ---

  Future<void> signInWithGoogle() async {
    try {
      state = AsyncValue.loading();
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        // clientId: 'PONER_AQUI_CLIENT_ID_SI_ES_IOS',
      );
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        state = AsyncValue.data(false); // Cancelado por el usuario
        return;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      
      if (idToken == null) {
        throw Exception('No se pudo obtener el ID Token de Google');
      }
      
      final authRepo = ref.read(authRepositoryProvider);
      final accessToken = await authRepo.loginWithGoogle(idToken);
      
      final secureStorage = ref.read(secureStorageProvider);
      AuthInterceptor.setToken(accessToken);
      await secureStorage.write(key: 'access_token', value: accessToken);
      
      state = AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithApple() async {
    try {
      state = AsyncValue.loading();
      
      final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      final identityToken = credential.identityToken;
      
      if (identityToken == null) {
        throw Exception('No se pudo obtener el Identity Token de Apple');
      }
      
      final authRepo = ref.read(authRepositoryProvider);
      final accessToken = await authRepo.loginWithApple(identityToken);
      
      final secureStorage = ref.read(secureStorageProvider);
      AuthInterceptor.setToken(accessToken);
      await secureStorage.write(key: 'access_token', value: accessToken);
      
      state = AsyncValue.data(true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
