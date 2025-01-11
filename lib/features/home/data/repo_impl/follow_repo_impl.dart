import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/domain/repos/follow_repo.dart';

class FollowRepoImpl extends FollowRepo {
  final DatabaseService databaseService;

  FollowRepoImpl({required this.databaseService});
  @override
  Future<Either<Failure, List<UserEntity>>> getFollowersSuggestions({
    required String currentUserId,
  }) async {
    try {
      List data = await databaseService.getData(
        path: BackendEndpoints.getSuggestionFollowers,
        queryConditions: [
          QueryCondition(
            field: "userId",
            operator: QueryOperator.isNotEqualTo,
            value: currentUserId,
          )
        ],
      );
      List<UserEntity> suggestionUsers = data
          .map(
            (json) => UserModel.fromJson(json),
          )
          .toList();
      return right(suggestionUsers);
    } catch (e) {
      log("Exception in FollowRepoImpl.getFollowersSuggestions() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get suggestions"));
    }
  }
}
