import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

abstract class UsersSearchRepo {
  Future<Either<Failure, List<UserEntity>>> searchUsers({
    required String query,
    int? limit,
  });
}
