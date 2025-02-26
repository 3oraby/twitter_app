import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/helpers/functions/delete_user_data_from_prefs.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final UserRepo userRepo;
  AuthRepoImpl({
    required this.firebaseAuthService,
    required this.userRepo,
  });

  @override
  Future<Either<Failure, User>> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      User user = await firebaseAuthService.createUserWithEmailAndPassword(
          email: email, password: password);

      return right(user);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      User user = await firebaseAuthService.signInWithEmailAndPassword(
          email: email, password: password);
      await userRepo.getCurrentUserData();
      return right(user);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  User getCurrentFirebaseAuthUser() {
    try {
      User user = firebaseAuthService.getCurrentFirebaseAuthUser();
      log("current user data: id:  ${user.uid} ---- email: ${user.email}");
      return user;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<Either<Failure, Success>> logOut() async {
    try {
      await firebaseAuthService.logOut();
      await deleteUserDataFromPrefs();
      return right(Success());
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      User? user = firebaseAuthService.firebaseAuth.currentUser;

      if (user == null) {
        log("No user is currently signed in.");
        return left(const ServerFailure(
            message:
                "Cannot change your password because you are not signed in."));
      }

      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      return right(Success());
    } on FirebaseAuthException catch (e) {
      log("Error in authRepoImpl.changePassword : ${e.code}");

      String errorMessage;
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = "Your current password is incorrect.";
          break;
        case 'weak-password':
          errorMessage =
              "Your new password is too weak. Please choose a stronger password.";
          break;
        case 'requires-recent-login':
          errorMessage =
              "For security reasons, please log in again before changing your password.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Network error! Please check your internet connection and try again.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many failed attempts. Please try again later.";
          break;
        default:
          errorMessage = "An unexpected error occurred. Please try again.";
      }

      return left(ServerFailure(message: errorMessage));
    } catch (e) {
      log("Unexpected error in authRepoImpl.changePassword : ${e.toString()}");
      return left(const ServerFailure(
          message: "Something went wrong. Please try again later."));
    }
  }
}
