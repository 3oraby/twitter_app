import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/search/domain/repos/users_search_repo.dart';

class UsersSearchRepoImpl extends UsersSearchRepo {
  final DatabaseService databaseService;

  UsersSearchRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers({
    required String query,
    required int limit,
  }) async {
    try {
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
        limit: limit,
      );

      List lastNameMatches = await databaseService.getData(
        path: BackendEndpoints.getUsers,
        queryConditions: conditionsLastName,
        orderByFields: ["lastName"],
        limit: limit,
      );

      Set userDocs = {...firstNameMatches, ...lastNameMatches};

      if (userDocs.isEmpty) return right([]);

      List<UserEntity> users = userDocs.map((doc) {
        return UserModel.fromJson(doc.data()).toEntity();
      }).toList();

      return right(users);
    } catch (e) {
      log("Exception in UsersSearchRepoImpl.searchUsers() ${e.toString()}");
      return left(const ServerFailure(
          message: "Unable to fetch users. Please try again."));
    }
  }
}
