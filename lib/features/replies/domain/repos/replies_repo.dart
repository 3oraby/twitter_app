import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';

abstract class RepliesRepo {
  Future<Either<Failure, ReplyDetailsEntity>> makeNewReply({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  });

  Future<Either<Failure, List<ReplyDetailsEntity>>> getCommentReplies({
    required String commentId,
  });

  Future<Either<Failure, Success>> deleteReply({
    required String commentId,
    required String replyId,
    List<String>? removedMediaFiles,
  });

  Future<Either<Failure, ReplyDetailsEntity>> updateReply({
    required String replyId,
    required Map<String, dynamic> data,
    required List<String>? constantMediaUrls,
    required List<String>? removedMediaUrls,
    required List<File>? mediaFiles,
  });
}
