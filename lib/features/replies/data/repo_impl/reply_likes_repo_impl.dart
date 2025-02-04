import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/replies/data/models/reply_likes_model.dart';
import 'package:twitter_app/features/replies/domain/repos/reply_likes_repo.dart';

class ReplyLikesRepoImpl extends ReplyLikesRepo {
  final DatabaseService databaseService;

  ReplyLikesRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, Success>> toggleReplyLikes(
      {required Map<String, dynamic> data}) async {
    try {
      ReplyLikesModel replyLikesModel = ReplyLikesModel.fromJson(data);

      var existingLike = await databaseService.getData(
        path: BackendEndpoints.getReplyLikes,
        queryConditions: [
          QueryCondition(
            field: "userId",
            value: replyLikesModel.userId,
          ),
          QueryCondition(
            field: "replyId",
            value: replyLikesModel.replyId,
          ),
        ],
      );

      if (existingLike.isEmpty) {
        await databaseService.addData(
          path: BackendEndpoints.toggleReplyLikes,
          data: replyLikesModel.toJson(),
        );

        await databaseService.addToList(
          path: BackendEndpoints.updateReplyData,
          documentId: replyLikesModel.replyId,
          field: "likes",
          value: replyLikesModel.userId,
        );
      } else {
        await databaseService.deleteData(
          path: BackendEndpoints.toggleReplyLikes,
          documentId: existingLike.first.id,
        );

        await databaseService.removeFromList(
          path: BackendEndpoints.updateReplyData,
          documentId: replyLikesModel.replyId,
          field: "likes",
          value: replyLikesModel.userId,
        );
      }

      return right(Success());
    } catch (e) {
      log("exception in ReplyLikesRepoImpl.toggleReplyLikes() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to toggle like"));
    }
  }
}
