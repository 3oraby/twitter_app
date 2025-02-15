import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';

abstract class CommentLikesRepo {
  Future<Either<Failure, String>> toggleCommentLikes({
    required Map<String, dynamic> data,
  });
}
