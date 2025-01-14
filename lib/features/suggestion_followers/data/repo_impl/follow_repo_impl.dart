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
      return left(const ServerFailure(message: "Failed to get suggestions."));
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
      var existingRelation = await databaseService.getData(
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

      log("result from follow  ${existingRelation.toString()} ");
      if (existingRelation.isEmpty) {
        if (!isMakingFollowRelation) {
          log("not expected follow type in follow repo");
          return left(const ServerFailure(
              message:
                  "The operation could not be completed due to an unexpected issue. Please try again later."));
        }

        return await _followUser(data, followingRelationshipModel);
      } else {
        if (isMakingFollowRelation) {
          log("not expected follow type in follow repo");
          return left(const ServerFailure(
              message:
                  "The operation could not be completed due to an unexpected issue. Please try again later."));
        }
        return await _unfollowUser(
            existingRelation.first.id, followingRelationshipModel);
      }
    } catch (e) {
      log("Exception in FollowRepoImpl.getFollowersSuggestions() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get suggestions"));
    }
  }

  Future<Either<Failure, Success>> _followUser(
    Map<String, dynamic> data,
    FollowingRelationshipModel relationshipModel,
  ) async {
    try {
      await databaseService.addData(
        path: BackendEndpoints.toggleFollowRelationShip,
        data: data,
      );

      await _updateUserStats(
        relationshipModel.followedId,
        "nFollowers",
        isIncrement: true,
      );
      await _updateUserStats(
        relationshipModel.followingId,
        "nFollowing",
        isIncrement: true,
      );

      return right(Success());
    } catch (e) {
      log("Exception in FollowRepoImpl._followUser: ${e.toString()}");
      return left(const ServerFailure(
        message: ("Failed to follow user. Please try again later."),
      ));
    }
  }

  Future<Either<Failure, Success>> _unfollowUser(
    String documentId,
    FollowingRelationshipModel relationshipModel,
  ) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoints.toggleFollowRelationShip,
        documentId: documentId,
      );

      await _updateUserStats(
        relationshipModel.followedId,
        "nFollowers",
        isIncrement: false,
      );
      await _updateUserStats(
        relationshipModel.followingId,
        "nFollowing",
        isIncrement: false,
      );

      return right(Success());
    } catch (e) {
      log("Exception in FollowRepoImpl._unfollowUser: ${e.toString()}");
      return left(const ServerFailure(
        message: "Failed to unfollow user. Please try again later.",
      ));
    }
  }

  Future<void> _updateUserStats(
    String userId,
    String field, {
    required bool isIncrement,
  }) async {
    try {
      if (isIncrement) {
        await databaseService.incrementField(
          path: BackendEndpoints.updateUserData,
          documentId: userId,
          field: field,
        );
      } else {
        await databaseService.decrementField(
          path: BackendEndpoints.updateUserData,
          documentId: userId,
          field: field,
        );
      }
    } catch (e) {
      log("error in followRepoImpl._updateUserStats() ${e.toString()}");
      throw Exception("Failed to update user stats.");
    }
  }
}
