import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> createUserWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, User>> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, User>> createUserWithPhoneNumber();

  User getCurrentFirebaseAuthUser();
}
