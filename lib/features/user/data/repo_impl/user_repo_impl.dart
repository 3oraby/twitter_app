import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/helpers/functions/save_user_data_in_prefs.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

class UserRepoImpl extends UserRepo {
  final DatabaseService databaseService;
  final FirebaseAuthService firebaseAuthService;

  UserRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
  });

  @override
  Future<Either<Failure, Success>> addUserToFirestore({
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    try {
      log('execute UserRepoImpl.addUserToFirestore()');
      await databaseService.addData(
        path: BackendEndpoints.addUserData,
        data: data,
        documentId: documentId,
      );
      UserEntity userEntity = UserModel.fromJson(data).toEntity();
      await saveUserDataInPrefs(user: userEntity);
      return right(Success());
    } catch (e) {
      await firebaseAuthService.deleteCurrentUser();
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserData() async {
    try {
      log('execute UserRepoImpl.getCurrentUserData()');
      User user = firebaseAuthService.getCurrentFirebaseAuthUser();
      Map<String, dynamic> userData = await databaseService.getData(
        path: BackendEndpoints.getUserData,
        documentId: user.uid,
      ) as Map<String, dynamic>;
      UserEntity userEntity = UserModel.fromJson(userData).toEntity();
      await saveUserDataInPrefs(user: userEntity);
      return right(userEntity);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> updateUserData({
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    try {
      log('execute UserRepoImpl.updateUserData()');
      await databaseService.updateData(
        path: BackendEndpoints.updateUserData,
        documentId: documentId,
        data: data,
      );
      return right(Success());
    } catch (e) {
      log("error in updataUserData service in userRepoImpl");
      return left(ServerFailure(message: e.toString()));
    }
  }
}
