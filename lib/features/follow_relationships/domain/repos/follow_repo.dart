import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

abstract class FollowRepo {
  Future<Either<Failure, List<UserEntity>>> getFollowersSuggestions({
    required String currentUserId,
  });

  Future<Either<Failure, Success>> toggleFollowRelationShip({
    required Map<String, dynamic> data,
    required bool isMakingFollowRelation,
  });

  Future<Either<Failure, List<UserEntity>>> getUserConnections({
    required String currentUserId,
    required bool isFetchingFollowers,
  });
}
