import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

abstract class TweetRepo {
  Future<Either<Failure, TweetDetailsEntity>> makeNewTweet({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  });

  Future<Either<Failure, List<TweetDetailsEntity>>> getTweets({
    required GetTweetsFilterOptionModel tweetFilterOption,
    String? targetUserId,
    String? query,
  });

  Future<Either<Failure, Success>> deleteTweet({
    required String tweetId,
    List<String>? mediaFiles,
  });

  Future<Either<Failure, TweetDetailsEntity>> updateTweet({
    required String tweetId,
    required Map<String, dynamic> data,
    required List<String>? constantMediaUrls,
    required List<String>? removedMediaUrls,
    required List<File>? mediaFiles,
  });
}
