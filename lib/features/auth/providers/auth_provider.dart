import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../core/network/auth_interceptor.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';

part 'auth_provider.g.dart';

const _kTokenNotFoundError = 'Token not found in response';

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
    state = const AsyncValue.loading();
    try {
      final response = await _repository.login(email, password);
      final token = response['access_token'];
      final refreshToken = response['refresh_token'];
      if (token != null) {
        AuthInterceptor.setToken(token);
        if (refreshToken != null) {
          AuthInterceptor.setRefreshToken(refreshToken);
        }
        await _storage.write(key: 'access_token', value: token);
        if (refreshToken != null) {
          await _storage.write(key: 'refresh_token', value: refreshToken);
        }
        state = const AsyncValue.data(true);
      } else {
        throw Exception(_kTokenNotFoundError);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password, String nombre, String apellido, {String? genero, String? fechanacimiento}) async {
    state = const AsyncValue.loading();
    try {
      await _repository.register(email, password, nombre, apellido, genero: genero, fechanacimiento: fechanacimiento);
      // Auto-login since the backend now auto-confirms the email
      await login(email, password);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    AuthInterceptor.clearToken();
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    state = const AsyncValue.data(false);
  }

  // --- SOCIAL LOGIN ---

  Future<void> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: '964868283203-03dia1hcs0tldoab5tusugcr21gms149.apps.googleusercontent.com',
      );
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        state = const AsyncValue.data(false); // Cancelado por el usuario
        return;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      
      if (idToken == null) {
        throw Exception('No se pudo obtener el ID Token de Google');
      }
      
      final authRepo = ref.read(authRepositoryProvider);
      final response = await authRepo.loginWithGoogle(idToken);
      final token = response['access_token'];
      final refreshToken = response['refresh_token'];
      
      if (token != null) {
        AuthInterceptor.setToken(token);
        if (refreshToken != null) {
          AuthInterceptor.setRefreshToken(refreshToken);
        }
        await _storage.write(key: 'access_token', value: token);
        if (refreshToken != null) {
          await _storage.write(key: 'refresh_token', value: refreshToken);
        }
        state = const AsyncValue.data(true);
      } else {
        throw Exception(_kTokenNotFoundError);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> linkWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: '964868283203-03dia1hcs0tldoab5tusugcr21gms149.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        return; // Cancelado por el usuario
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      
      if (idToken == null) {
        throw Exception('No se pudo obtener el ID Token de Google');
      }
      
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.linkWithGoogle(idToken);
      // Actualizar el perfil u otras cosas si es necesario
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      state = const AsyncValue.loading();
      
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        
        final authRepo = ref.read(authRepositoryProvider);
        final response = await authRepo.loginWithFacebook(accessToken.token);
        final token = response['access_token'];
        final refreshToken = response['refresh_token'];
        
        if (token != null) {
          AuthInterceptor.setToken(token);
          if (refreshToken != null) {
            AuthInterceptor.setRefreshToken(refreshToken);
          }
          await _storage.write(key: 'access_token', value: token);
          if (refreshToken != null) {
            await _storage.write(key: 'refresh_token', value: refreshToken);
          }
          state = const AsyncValue.data(true);
        } else {
          throw Exception(_kTokenNotFoundError);
        }
      } else if (result.status == LoginStatus.cancelled) {
        state = const AsyncValue.data(false);
      } else {
        throw Exception(result.message ?? 'Error desconocido con Facebook');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> linkWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final authRepo = ref.read(authRepositoryProvider);
        await authRepo.linkWithFacebook(accessToken.token);
      } else if (result.status == LoginStatus.cancelled) {
        return; // Cancelado
      } else {
        throw Exception(result.message ?? 'Error desconocido con Facebook');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signInWithApple() async {
    try {
      state = const AsyncValue.loading();
      
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
      final response = await authRepo.loginWithApple(identityToken);
      final token = response['access_token'];
      final refreshToken = response['refresh_token'];
      
      if (token != null) {
        AuthInterceptor.setToken(token);
        if (refreshToken != null) {
          AuthInterceptor.setRefreshToken(refreshToken);
        }
        await _storage.write(key: 'access_token', value: token);
        if (refreshToken != null) {
          await _storage.write(key: 'refresh_token', value: refreshToken);
        }
        state = const AsyncValue.data(true);
      } else {
        throw Exception(_kTokenNotFoundError);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
