import 'package:flutter/cupertino.dart';
import 'package:todo_v3/services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<AppUser> _signIn(Future<AppUser> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<AppUser> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
}
