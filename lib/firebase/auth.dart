import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'storage.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GithubAuthProvider _githubProvider = GithubAuthProvider();
  final GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();

  User? get currentUser => _auth.currentUser;

  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required File avatar,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = cred.user;
      if (user != null) {
        user.updateDisplayName(displayName);
        user.updatePhotoURL(await Storage().uploadAvatar(user.uid, avatar));
      }
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user?.emailVerified == true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      await _auth.signInWithProvider(_googleAuthProvider);
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  Future<bool> signInWithGithub() async {
    try {
      await _auth.signInWithProvider(_githubProvider);
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }
}
