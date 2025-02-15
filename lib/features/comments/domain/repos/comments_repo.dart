import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';

abstract class CommentsRepo {
  Future<Either<Failure, CommentDetailsEntity>> makeNewComment({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  });

  Future<Either<Failure, List<CommentDetailsEntity>>> getTweetComments({
    required String tweetId,
    String? filter,
  });

  Future<Either<Failure, CommentDetailsEntity>> updateComment({
    required String commentId,
    required Map<String, dynamic> data,
    required List<String>? constantMediaUrls,
    required List<String>? removedMediaUrls,
    required List<File>? mediaFiles,
  });
}
