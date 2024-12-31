import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/helpers/functions/delete_user_data_from_prefs.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  AuthRepoImpl({required this.firebaseAuthService});

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
  Future<Either<Failure, User>> createUserWithPhoneNumber() {
    throw UnimplementedError();
  }
}
