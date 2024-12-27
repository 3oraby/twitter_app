import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/errors/custom_exception.dart';

class FirebaseAuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<User> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log("Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()} and code is ${e.code}");
      if (e.code == 'weak-password') {
        throw const CustomException(
            message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw const CustomException(
            message: 'The account already exists for that email.');
      } else if (e.code == 'network-request-failed') {
        throw const CustomException(
            message: 'Please check your internet connection.');
      } else {
        throw const CustomException(
            message: 'An error occurred. Please try again.');
      }
    } catch (e) {
      log("Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()}");
      throw CustomException(message: e.toString());
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log("Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()} and code is ${e.code}");
      if (e.code == 'user-not-found') {
        throw const CustomException(
            message: 'The email or password is incorrect.');
      } else if (e.code == 'wrong-password') {
        throw const CustomException(
            message: 'The email or password is incorrect.');
      } else if (e.code == 'invalid-credential') {
        throw const CustomException(
            message: 'The email or password is incorrect.');
      } else if (e.code == 'network-request-failed') {
        throw const CustomException(
            message: 'Please check your internet connection.');
      } else if (e.code == 'invalid-email') {
        throw const CustomException(
            message: 'Please enter a valid email address.');
      } else {
        throw const CustomException(
            message: 'An error occurred. Please try again.');
      }
    } catch (e) {
      throw const CustomException(
          message: 'An error occurred. Please try again.');
    }
  }

  User getCurrentFirebaseAuthUser() {
    try {
      User? user = firebaseAuth.currentUser;
      if (user == null) {
        throw const CustomException(message: "Current user does not exist");
      }
      return user;
    } catch (e) {
      log("Exception in FirebaseAuthService.getCurrentUser: ${e.toString()}");
      throw const CustomException(
          message: 'An error occurred. Please try again.');
    }
  }

  Future<void> deleteCurrentUser() async {
    log("delete current user");
    await firebaseAuth.currentUser!.delete();
  }

  bool isUserLoggedIn() {
    bool isLoggedIn = firebaseAuth.currentUser != null;
    log("check if user logged in == $isLoggedIn");
    return isLoggedIn;
  }
}
