import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AppUser {
  AppUser({@required this.uid, this.username});
  final String uid;
  final String username;
}

abstract class AuthBase {
  Stream<AppUser> get onAuthStateChanged;
  String get userName;
  Future<AppUser> currentUser();
  Future<AppUser> signInAnonymously();
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithEmailAndPassword(String email, String password);
  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password, String username);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  AppUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return AppUser(uid: user.uid, username: user.displayName);
  }

  String get userName {
    return _firebaseAuth.currentUser.displayName;
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await authResult.user.updateProfile(displayName: username);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> signInWithEmailAndPassword(
      String email, String password) async {
    final authresult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print("DisplaName: ${authresult.user.displayName}");
    return _userFromFirebase(authresult.user);
  }

  @override
  Future<AppUser> currentUser() async {
    _firebaseAuth.authStateChanges().listen((User user) {
      if (user == null) {
        print("User signed out.");
      } else {
        return _userFromFirebase(user);
      }
    });
  }

  @override
  Stream<AppUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<AppUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
