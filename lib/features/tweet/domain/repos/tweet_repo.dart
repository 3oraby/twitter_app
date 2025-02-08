import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

abstract class TweetRepo {
  Future<Either<Failure, TweetDetailsEntity>> makeNewTweet({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  });

  Future<Either<Failure, List<TweetDetailsEntity>>> getTweets({
    bool? isForFollowingOnly,
  });

  Future<Either<Failure, Success>> deleteTweet({
    required String tweetId,
  });
}
