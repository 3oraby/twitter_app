import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';

abstract class UsersSearchRepo {
  Future<Either<Failure, List<UserWithFollowStatusEntity>>> searchUsers({
    required String query,
    int? limit,
  });
}
