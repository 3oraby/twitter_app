import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/comments/data/models/comment_likes_model.dart';
import 'package:twitter_app/features/comments/domain/repos/comment_likes_repo.dart';

class CommentLikesRepoImpl extends CommentLikesRepo {
  final DatabaseService databaseService;

  CommentLikesRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, String>> toggleCommentLikes(
      {required Map<String, dynamic> data}) async {
    try {
      CommentLikesModel commentLikesModel = CommentLikesModel.fromJson(data);

      String likeId;
      var existingLike = await databaseService.getData(
        path: BackendEndpoints.getCommentLikes,
        queryConditions: [
          QueryCondition(
            field: "userId",
            value: commentLikesModel.userId,
          ),
          QueryCondition(
            field: "commentId",
            value: commentLikesModel.commentId,
          ),
        ],
      );

      if (existingLike.isEmpty) {
        String? id = await databaseService.addData(
          path: BackendEndpoints.toggleCommentLikes,
          data: commentLikesModel.toJson(),
        );

        await databaseService.addToList(
          path: BackendEndpoints.updateCommentData,
          documentId: commentLikesModel.commentId,
          field: "likes",
          value: commentLikesModel.userId,
        );
        likeId = id!;
      } else {
        await databaseService.deleteData(
          path: BackendEndpoints.toggleCommentLikes,
          documentId: existingLike.first.id,
        );

        await databaseService.removeFromList(
          path: BackendEndpoints.updateCommentData,
          documentId: commentLikesModel.commentId,
          field: "likes",
          value: commentLikesModel.userId,
        );
        likeId = existingLike.first.id;
      }

      return right(likeId);
    } catch (e) {
      log("exception in CommentLikesRepoImpl.toggleCommentLikes() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to toggle like"));
    }
  }
}
