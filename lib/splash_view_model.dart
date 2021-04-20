import 'dart:async';

class SplashViewModel {
  Future<void> getTime() async {
    return Future.delayed(const Duration(seconds: 2));
  }
}
