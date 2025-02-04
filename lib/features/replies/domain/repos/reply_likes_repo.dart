import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';

abstract class ReplyLikesRepo {
  Future<Either<Failure, Success>> toggleReplyLikes({
    required Map<String, dynamic> data,
  });
}
