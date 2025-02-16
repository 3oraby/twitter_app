import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_likes_model.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_likes_repo.dart';

class TweetLikesRepoImpl extends TweetLikesRepo {
  final DatabaseService databaseService;
  TweetLikesRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, Success>> toggleTweetLike({
    required Map<String, dynamic> data,
  }) async {
    try {
      TweetLikesModel tweetLikesModel = TweetLikesModel.fromJson(data);
      String path = BackendEndpoints.toggleTweetLike;

      var existingLike = await databaseService.getData(
        path: path,
        queryConditions: [
          QueryCondition(
            field: "userId",
            value: tweetLikesModel.userId,
          ),
          QueryCondition(
            field: "tweetId",
            value: tweetLikesModel.tweetId,
          ),
        ],
      );

      if (existingLike.isEmpty) {
        await databaseService.addData(
          path: path,
          data: tweetLikesModel.toJson(),
        );

        await databaseService.incrementField(
          path: BackendEndpoints.updateTweetData,
          documentId: tweetLikesModel.tweetId,
          field: "likesCount",
        );
      } else {
        await databaseService.deleteData(
          path: path,
          documentId: existingLike.first.id,
        );

        await databaseService.decrementField(
          path: BackendEndpoints.updateTweetData,
          documentId: tweetLikesModel.tweetId,
          field: "likesCount",
        );
      }

      return right(Success());
    } catch (e) {
      log("exception in tweetLikesRepoImpl.addNewLike() ${e.toString()}");
      return left(const ServerFailure(message: "Couldn't update your like"));
    }
  }
}
