import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/follow_relationships/data/models/following_relationship_model.dart';
import 'package:twitter_app/features/follow_relationships/data/models/user_with_follow_status_model.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';
import 'package:twitter_app/features/search/domain/repos/users_search_repo.dart';

class UsersSearchRepoImpl extends UsersSearchRepo {
  final DatabaseService databaseService;

  UsersSearchRepoImpl({required this.databaseService});
  @override
  Future<Either<Failure, List<UserWithFollowStatusEntity>>> searchUsers({
    required String query,
    int? limit,
  }) async {
    try {
      final UserEntity currentUser = getCurrentUserEntity();

      List<QueryCondition> conditionsFirstName = [
        QueryCondition(
          field: "firstName",
          operator: QueryOperator.greaterThanOrEqualTo,
          value: query,
        ),
        QueryCondition(
          field: "firstName",
          operator: QueryOperator.lessThan,
          value: '$query\uf8ff',
        ),
      ];

      List<QueryCondition> conditionsLastName = [
        QueryCondition(
          field: "lastName",
          operator: QueryOperator.greaterThanOrEqualTo,
          value: query,
        ),
        QueryCondition(
          field: "lastName",
          operator: QueryOperator.lessThan,
          value: '$query\uf8ff',
        ),
      ];

      List firstNameMatches = await databaseService.getData(
        path: BackendEndpoints.getUsers,
        queryConditions: conditionsFirstName,
        orderByFields: ["firstName"],
        descending: [false],
        limit: limit,
      );

      List lastNameMatches = await databaseService.getData(
        path: BackendEndpoints.getUsers,
        queryConditions: conditionsLastName,
        orderByFields: ["lastName"],
        descending: [false],
        limit: limit,
      );

      Set userDocs = {...firstNameMatches, ...lastNameMatches};

      if (userDocs.isEmpty) return right([]);

      List currentUserFollowers = await databaseService.getData(
        path: BackendEndpoints.toggleFollowRelationShip,
        queryConditions: [
          QueryCondition(
            field: "followedId",
            value: currentUser.userId,
          ),
        ],
      );

      List currentUserFollowings = await databaseService.getData(
        path: BackendEndpoints.toggleFollowRelationShip,
        queryConditions: [
          QueryCondition(
            field: "followingId",
            value: currentUser.userId,
          ),
        ],
      );

      Set<String> currentUserFollowersSet = currentUserFollowers
          .map((doc) =>
              FollowingRelationshipModel.fromJson(doc.data()).followingId)
          .toSet();

      Set<String> currentUserFollowingsSet = currentUserFollowings
          .map((doc) =>
              FollowingRelationshipModel.fromJson(doc.data()).followedId)
          .toSet();

      List<UserWithFollowStatusEntity> usersWithStatus = userDocs.map((doc) {
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

      return right(usersWithStatus);
    } catch (e) {
      log("Exception in UsersSearchRepoImpl.searchUsers() ${e.toString()}");
      return left(const ServerFailure(
          message: "Unable to fetch users. Please try again."));
    }
  }
}
