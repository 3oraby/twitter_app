import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/save_user_data_in_prefs.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/data/models/following_relationship_model.dart';
import 'package:twitter_app/features/follow_relationships/data/models/user_with_follow_status_model.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/repos/follow_repo.dart';

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
  Future<Either<Failure, List<UserWithFollowStatusEntity>>> getUserConnections({
    required String targetUserId,
    required bool isFetchingFollowers,
  }) async {
    try {
      final UserEntity currentUser = getCurrentUserEntity();

      List followersRelationships = [];
      List followingsRelationships = [];

      followersRelationships = await databaseService.getData(
        path: BackendEndpoints.toggleFollowRelationShip,
        queryConditions: [
          QueryCondition(field: "followedId", value: targetUserId),
        ],
      );

      followingsRelationships = await databaseService.getData(
        path: BackendEndpoints.toggleFollowRelationShip,
        queryConditions: [
          QueryCondition(field: "followingId", value: targetUserId),
        ],
      );

      Set<String> userIds = {};

      if (isFetchingFollowers) {
        for (var doc in followersRelationships) {
          userIds
              .add(FollowingRelationshipModel.fromJson(doc.data()).followingId);
        }
      } else {
        for (var doc in followingsRelationships) {
          userIds
              .add(FollowingRelationshipModel.fromJson(doc.data()).followedId);
        }
      }

      if (userIds.isEmpty) {
        return right([]);
      }

      List res = await databaseService.getData(
        path: BackendEndpoints.getUserConnections,
        queryConditions: [
          QueryCondition(
            field: "userId",
            operator: QueryOperator.whereIn,
            value: userIds.toList(),
          ),
        ],
      );

      Set<String> targetFollowersSet = followersRelationships
          .map((doc) =>
              FollowingRelationshipModel.fromJson(doc.data()).followingId)
          .toSet();

      Set<String> targetFollowingsSet = followingsRelationships
          .map((doc) =>
              FollowingRelationshipModel.fromJson(doc.data()).followedId)
          .toSet();

      Set<String> currentUserFollowersSet = {};
      Set<String> currentUserFollowingsSet = {};

      if (targetUserId != currentUser.userId) {
        List currentUserFollowers = await databaseService.getData(
          path: BackendEndpoints.toggleFollowRelationShip,
          queryConditions: [
            QueryCondition(field: "followedId", value: currentUser.userId),
          ],
        );

        List currentUserFollowings = await databaseService.getData(
          path: BackendEndpoints.toggleFollowRelationShip,
          queryConditions: [
            QueryCondition(field: "followingId", value: currentUser.userId),
          ],
        );

        currentUserFollowersSet = currentUserFollowers
            .map((doc) =>
                FollowingRelationshipModel.fromJson(doc.data()).followingId)
            .toSet();

        currentUserFollowingsSet = currentUserFollowings
            .map((doc) =>
                FollowingRelationshipModel.fromJson(doc.data()).followedId)
            .toSet();
      } else {
        currentUserFollowersSet = targetFollowersSet;
        currentUserFollowingsSet = targetFollowingsSet;
      }

      List<UserWithFollowStatusEntity> userConnections = res.map((doc) {
        UserEntity user = UserModel.fromJson(doc.data()).toEntity();

        bool isFollowedByCurrentUser =
            currentUserFollowingsSet.contains(user.userId);

        bool isFollowingCurrentUser =
            currentUserFollowersSet.contains(user.userId);

        return UserWithFollowStatusModel(
          user: UserModel.fromEntity(user),
          isFollowingCurrentUser: isFollowingCurrentUser,
          isFollowedByCurrentUser: isFollowedByCurrentUser,
        );
      }).toList();

      return right(userConnections);
    } catch (e) {
      log("Exception in FollowRepoImpl.getUserConnections() ${e.toString()}");
      return left(
          const ServerFailure(message: "Failed to get user connections"));
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
      await _updateUserStatsInSharedPreferences(isIncrement: true);

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
      await _updateUserStatsInSharedPreferences(isIncrement: false);

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

  Future<void> _updateUserStatsInSharedPreferences({
    required bool isIncrement,
  }) async {
    try {
      UserEntity currentUser = getCurrentUserEntity();

      int updatedCount =
          isIncrement ? currentUser.nFollowing + 1 : currentUser.nFollowing - 1;

      UserEntity updatedUser = currentUser.copyWith(
        nFollowing: updatedCount,
      );

      await saveUserDataInPrefs(user: updatedUser);
    } catch (e) {
      log("error in FollowRepoImpl._updateUserStatsInSharedPreferences() ${e.toString()}");
      throw Exception("Failed to update user stats in SharedPreferences.");
    }
  }
}
