import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/constants/local_storage_data_names.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';
import 'package:twitter_app/features/auth/data/models/firebase_auth_user_model.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  AuthRepoImpl({required this.firebaseAuthService});

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      User user = await firebaseAuthService.createUserWithEmailAndPassword(
          email: email, password: password);

      saveFirebaseAuthUserDataInPrefs(user: user);
      return right(UserModel.fromFirebaseUser(user: user));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      User user = await firebaseAuthService.signInWithEmailAndPassword(
          email: email, password: password);
      return right(UserModel.fromFirebaseUser(user: user));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      User user = await firebaseAuthService.getCurrentUser();
      log("current user data: ${UserModel.fromFirebaseUser(user: user).toMap()}");
      return right(UserModel.fromFirebaseUser(user: user));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> saveFirebaseAuthUserDataInPrefs({required User user}) async {
    FirebaseAuthUserModel firebaseAuthUserModel =
        FirebaseAuthUserModel(email: user.email!, uid: user.uid);
    var jsonData = jsonEncode(firebaseAuthUserModel.toJson());
    await SharedPreferencesSingleton.setString(
        LocalStorageDataNames.kFirebaseAuthUserData, jsonData);
  }

  @override
  Future<Either<Failure, UserEntity>> createUserWithPhoneNumber() {
    throw UnimplementedError();
  }
}
