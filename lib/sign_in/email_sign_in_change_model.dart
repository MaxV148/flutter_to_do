import 'package:flutter/foundation.dart';
import 'package:todo_v3/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSigninChangeModel with ChangeNotifier {
  EmailSigninChangeModel({
    @required this.auth,
    this.email = "",
    this.password = "",
    this.username = "",
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthBase auth;

  String email;
  String password;
  String username;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    /// updateen den stream mit den
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password, username);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register.'
        : 'Have an account? Sign in.';
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        username: "",
        email: "",
        password: "",
        submitted: false,
        isLoading: false,
        formType: formType);
  }

  bool get isSignin {
    return this.formType == EmailSignInFormType.signIn ? true : false;
  }

  bool get canSubmit {
    return isLoading;
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateUserName(String username) => updateWith(username: username);

  void updateWith({
    String email,
    String password,
    String username,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.username = username ?? this.username;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
