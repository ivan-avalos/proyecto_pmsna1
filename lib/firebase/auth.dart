import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:linkchat/firebase/database.dart';

import '../models/user.dart';
import 'storage.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GithubAuthProvider _githubProvider = GithubAuthProvider();
  final GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();

  final Database _db = Database();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get userChanges => _auth.userChanges();

  Future<Either<User?, FirebaseException>> createUserWithEmailAndPassword({
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

      // Enviar correo de verificación
      await cred.user?.sendEmailVerification();

      User? user = cred.user;
      if (user != null) {
        String photoUrl = await Storage().uploadAvatar(user.uid, avatar);
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoUrl);
        // Store user in database
        _db.saveUser(FsUser(
          uid: user.uid,
          displayName: displayName,
          photoUrl: photoUrl,
          email: user.email!,
        ));
      }
      return Left(user);
    } catch (e) {
      if (kDebugMode) print(e);
      return Right(e as FirebaseException);
    }
  }

  Future<Either<User?, FirebaseException>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signOut();
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Left(cred.user);
    } catch (e) {
      if (kDebugMode) print(e);
      return Right(e as FirebaseException);
    }
  }

  Future<Either<User?, FirebaseException>> signInWithGoogle() async {
    try {
      UserCredential cred = await _auth.signInWithProvider(_googleAuthProvider);
      return Left(cred.user);
    } catch (e) {
      if (kDebugMode) print(e);
      return Right(e as FirebaseException);
    }
  }

  Future<Either<User?, FirebaseException>> signInWithGithub() async {
    try {
      UserCredential cred = await _auth.signInWithProvider(_githubProvider);
      return Left(cred.user);
    } catch (e) {
      if (kDebugMode) print(e);
      return Right(e as FirebaseException);
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
