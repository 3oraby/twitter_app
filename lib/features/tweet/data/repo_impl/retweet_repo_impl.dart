import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/tweet/data/models/retweet_model.dart';
import 'package:twitter_app/features/tweet/domain/repos/retweet_repo.dart';

class RetweetRepoImpl extends RetweetRepo {
  final DatabaseService databaseService;
  RetweetRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, Success>> toggleRetweet({
    required Map<String, dynamic> data,
  }) async {
    try {
      RetweetModel retweetModel = RetweetModel.fromJson(data);
      String path = BackendEndpoints.toggleRetweet;

      var existingRetweet = await databaseService.getData(
        path: path,
        queryConditions: [
          QueryCondition(
            field: "userId",
            value: retweetModel.userId,
          ),
          QueryCondition(
            field: "tweetId",
            value: retweetModel.tweetId,
          ),
        ],
      );

      if (existingRetweet.isEmpty) {
        await databaseService.addData(
          path: path,
          data: retweetModel.toJson(),
        );

        await databaseService.incrementField(
          path: BackendEndpoints.updateTweetData,
          documentId: retweetModel.tweetId,
          field: "retweetsCount",
        );
      } else {
        await databaseService.deleteData(
          path: path,
          documentId: existingRetweet.first.id,
        );

        await databaseService.decrementField(
          path: BackendEndpoints.updateTweetData,
          documentId: retweetModel.tweetId,
          field: "retweetsCount",
        );
      }

      return right(Success());
    } catch (e) {
      log("exception in retweetRepoImpl.toggleRetweet() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to toggle retweet"));
    }
  }
}
