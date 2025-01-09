import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/features/home/domain/entities/tweet_entity.dart';

abstract class TweetRepo {
  Future<Either<Failure, TweetEntity>> makeNewTweet({
    required Map<String, dynamic> data,
  });
}
