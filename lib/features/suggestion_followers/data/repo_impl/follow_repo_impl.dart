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
      List followRelationships = await databaseService.getData(
        path: BackendEndpoints.toggleFollowRelationShip,
        queryConditions: [
          QueryCondition(
            field: "followingId",
            value: currentUserId,
          ),
        ],
      );

      Set<String> followedUserIds = followRelationships
          .map((doc) =>
              FollowingRelationshipModel.fromJson(doc.data()).followedId)
          .toSet();

      List res = await databaseService.getData(
        path: BackendEndpoints.getSuggestionFollowers,
        queryConditions: [
          QueryCondition(
            field: "userId",
            operator: QueryOperator.isNotEqualTo,
            value: currentUserId,
          ),
        ],
      );

      List<UserEntity> suggestionUsers = res
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => !followedUserIds.contains(user.userId))
          .toList();

      return right(suggestionUsers);
    } catch (e) {
      log("Exception in FollowRepoImpl.getFollowersSuggestions() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get suggestions"));
    }
  }

  @override
  Future<Either<Failure, Success>> toggleFollowRelationShip({
    required Map<String, dynamic> data,
    required bool isMakingFollowRelation,
  }) async {
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
        // follow
        if (!isMakingFollowRelation) {
          log("not expected follow type in follow repo");
          return left(const ServerFailure(
              message:
                  "Can not follow this account right now, please try again later"));
        }

        await databaseService.addData(
          path: BackendEndpoints.toggleFollowRelationShip,
          data: data,
        );

        // Increment followers count for the followed user
        await databaseService.incrementField(
          path: BackendEndpoints.updateUserData,
          documentId: followingRelationshipModel.followedId,
          field: "nFollowers",
        );

        // Increment following count for the following user
        await databaseService.incrementField(
          path: BackendEndpoints.updateUserData,
          documentId: followingRelationshipModel.followingId,
          field: "nFollowing",
        );
      } else {
        // unfollow
        if (isMakingFollowRelation) {
          log("not expected follow type in follow repo");
          return left(const ServerFailure(
              message:
                  "Can not Unfollow this account right now, please try again later"));
        }

        await databaseService.deleteData(
          path: BackendEndpoints.toggleFollowRelationShip,
          documentId: result.first.id,
        );
        // Decrement followers and following counts
        await databaseService.decrementField(
          path: BackendEndpoints.updateUserData,
          documentId: followingRelationshipModel.followedId,
          field: "nFollowers",
        );
        await databaseService.decrementField(
          path: BackendEndpoints.updateUserData,
          documentId: followingRelationshipModel.followingId,
          field: "nFollowing",
        );
      }

      return right(Success());
    } catch (e) {
      log("Exception in FollowRepoImpl.getFollowersSuggestions() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get suggestions"));
    }
  }
}
