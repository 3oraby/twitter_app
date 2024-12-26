import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, UserEntity>> createUserWithPhoneNumber();

  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<void> saveFirebaseAuthUserDataInPrefs({required User user});
}
