import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_likes_model.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_likes_repo.dart';

class TweetLikesRepoImpl extends TweetLikesRepo {
  final DatabaseService databaseService;
  TweetLikesRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, Success>> addNewLike({
    required Map<String, dynamic> data,
  }) async {
    try {
      TweetLikesModel tweetLikesModel = TweetLikesModel.fromJson(data);
      await databaseService.addData(
        path:
            "${BackendEndpoints.getTweets}/${tweetLikesModel.tweetId}/${BackendEndpoints.addNewTweetLike}",
        data: tweetLikesModel.toJson(),
      );

      return right(Success());
    } catch (e) {
      log("exception in tweetLikesRepoImpl.addNewLike() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to add like"));
    }
  }

  @override
  Future<Either<Failure, Success>> removeLike() {
    throw UnimplementedError();
  }
}
