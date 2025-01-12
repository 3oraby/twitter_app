import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/suggestion_followers/data/models/following_relationship_model.dart';
import 'package:twitter_app/features/suggestion_followers/domain/repos/follow_repo.dart';

class FollowRepoImpl extends FollowRepo {
  final DatabaseService databaseService;

  FollowRepoImpl({required this.databaseService});
  @override
  Future<Either<Failure, List<UserEntity>>> getFollowersSuggestions({
    required String currentUserId,
  }) async {
    try {
      List res = await databaseService.getData(
        path: BackendEndpoints.getSuggestionFollowers,
        queryConditions: [
          QueryCondition(
            field: "userId",
            operator: QueryOperator.isNotEqualTo,
            value: currentUserId,
          )
        ],
      );
      List<UserEntity> suggestionUsers = res
          .map(
            (doc) => UserModel.fromJson(doc.data()),
          )
          .toList();
      return right(suggestionUsers);
    } catch (e) {
      log("Exception in FollowRepoImpl.getFollowersSuggestions() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get suggestions"));
    }
  }

  @override
  Future<Either<Failure, Success>> toggleFollowRelationShip(
      {required Map<String, dynamic> data}) async {
    try {
      FollowingRelationshipModel followingRelationshipModel =
          FollowingRelationshipModel.fromJson(data);
      var result = await databaseService.getData(
        path: BackendEndpoints.toggleFollowRelationShip,
        queryConditions: [
          QueryCondition(
            field: "followedId",
            value: followingRelationshipModel.followedId,
          ),
          QueryCondition(
            field: "followingId",
            value: followingRelationshipModel.followingId,
          ),
        ],
      );

      log("result from follow  ${result.toString()} ");
      if (result.isEmpty) {
        await databaseService.addData(
          path: BackendEndpoints.toggleFollowRelationShip,
          data: data,
        );
      } else {
        await databaseService.deleteData(
          path: BackendEndpoints.toggleFollowRelationShip,
          documentId: result.first.id,
        );
      }

      return right(Success());
    } catch (e) {
      log("Exception in FollowRepoImpl.getFollowersSuggestions() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get suggestions"));
    }
  }
}
