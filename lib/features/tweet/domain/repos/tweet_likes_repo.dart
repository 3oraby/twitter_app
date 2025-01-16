import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';

abstract class TweetLikesRepo {
  Future<Either<Failure, Success>> addNewLike({
    required Map<String, dynamic> data,
  });
  Future<Either<Failure, Success>> removeLike();
}
