import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void complete() {
    state = false;
  }
}

final splashProvider = NotifierProvider<SplashNotifier, bool>(() => SplashNotifier());

