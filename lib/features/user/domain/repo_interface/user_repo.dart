import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

abstract class UserRepo {
  Future<Either<Failure, Success>> addUserToFirestore({
    required Map<String, dynamic> data,
    required String documentId,
  });

  Future<Either<Failure, UserEntity>> getCurrentUserData();

  Future<Either<Failure, Success>> updateUserData({
    required Map<String, dynamic> data,
    required String documentId,
  });
}
