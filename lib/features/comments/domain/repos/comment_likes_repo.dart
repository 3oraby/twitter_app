import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';

abstract class CommentLikesRepo {
  Future<Either<Failure, Success>> toggleCommentLikes({
    required Map<String, dynamic> data,
  });
}
