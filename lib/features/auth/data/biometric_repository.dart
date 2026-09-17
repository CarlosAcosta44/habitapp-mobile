import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_repository.g.dart';

@riverpod
BiometricRepository biometricRepository(Ref ref) {
  return BiometricRepository(LocalAuthentication());
}

class BiometricRepository {
  final LocalAuthentication _auth;

  BiometricRepository(this._auth);

  Future<bool> isBiometricAvailable() async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Por favor, autentícate para acceder a HabitApp',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Autenticación Biométrica',
            cancelButton: 'Cancelar',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancelar',
          ),
        ],
      );
    } on PlatformException {
      return false;
    }
  }
}
