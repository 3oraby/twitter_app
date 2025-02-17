import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/storage_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/data/models/comment_details_model.dart';
import 'package:twitter_app/features/comments/data/models/comment_model.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';

class CommentsRepoImpl extends CommentsRepo {
  final DatabaseService databaseService;
  final StorageService storageService;
  CommentsRepoImpl({
    required this.databaseService,
    required this.storageService,
  });

  @override
  Future<Either<Failure, CommentDetailsEntity>> makeNewComment({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  }) async {
    try {
      CommentModel commentModel = CommentModel.fromJson(data);

      List<String> mediaUrl = [];
      if (mediaFiles != null) {
        for (File file in mediaFiles) {
          String fileUrl = await storageService.uploadFile(
            file,
            BackendEndpoints.uploadFiles,
          );
          mediaUrl.add(fileUrl);
        }
      }

      commentModel.mediaUrl = mediaUrl;
      String? id = await databaseService.addData(
        path: BackendEndpoints.makeNewComment,
        data: commentModel.toJson(),
      );

      await databaseService.incrementField(
        path: BackendEndpoints.updateTweetData,
        documentId: commentModel.tweetId,
        field: "commentsCount",
      );

      CommentDetailsModel commentDetailsModel = CommentDetailsModel(
        tweetId: commentModel.tweetId,
        commentId: id!,
        comment: commentModel.toEntity(),
      );
      return right(commentDetailsModel.toEntity());
    } catch (e) {
      log("Exception in CommentsRepoImpl.makeNewComment() ${e.toString()}");
      return const Left(
        ServerFailure(
            message:
                "Unable to post the comment right now, please try again later."),
      );
    }
  }

  @override
  Future<Either<Failure, List<CommentDetailsEntity>>> getTweetComments({
    required String tweetId,
    String? filter,
  }) async {
    try {
      final UserEntity currentUser = getCurrentUserEntity();
      List<String>? orderByFields;
      List<bool>? descending;

      if (filter == "Most relevant replies") {
        orderByFields = ["repliesCount", "likes"];
        descending = [true, true];
      } else if (filter == "Most liked replies") {
        orderByFields = ["likes", "createdAt"];
        descending = [true, false];
      } else if (filter == "Most recent replies") {
        orderByFields = ["createdAt", "repliesCount"];
        descending = [true, true];
      }

      List<CommentDetailsEntity> comments = [];
      List res = await databaseService.getData(
        path: BackendEndpoints.getComments,
        queryConditions: [
          QueryCondition(
            field: "tweetId",
            value: tweetId,
          ),
        ],
        orderByFields: orderByFields,
        descending: descending,
      );

      comments = res.map((doc) {
        CommentModel commentModel = CommentModel.fromJson(doc.data());
        bool isCommentLikedByCurrentUser =
            commentModel.likes?.contains(currentUser.userId) ?? false;

        CommentDetailsModel commentDetailsModel = CommentDetailsModel(
          tweetId: commentModel.tweetId,
          commentId: doc.id,
          comment: commentModel,
          isLiked: isCommentLikedByCurrentUser,
        );
        return commentDetailsModel.toEntity();
      }).toList();
      return right(comments);
    } catch (e) {
      log("Exception in CommentsRepoImpl.getTweetComments() ${e.toString()}");
      return const Left(
        ServerFailure(
            message:
                "Unable to fetch comments right now, please try again later."),
      );
    }
  }

  @override
  Future<Either<Failure, CommentDetailsEntity>> updateComment({
    required String commentId,
    required Map<String, dynamic> data,
    required List<String>? constantMediaUrls,
    required List<String>? removedMediaUrls,
    required List<File>? mediaFiles,
  }) async {
    try {
      List<String> mediaUrls = constantMediaUrls ?? [];

      if (removedMediaUrls != null && removedMediaUrls.isNotEmpty) {
        await storageService.deleteFiles(removedMediaUrls);
      }

      CommentDetailsEntity commentDetailsEntity =
          CommentDetailsModel.fromJson(data).toEntity();

      if (mediaFiles != null) {
        for (File file in mediaFiles) {
          String fileUrl = await storageService.uploadFile(
            file,
            BackendEndpoints.uploadFiles,
          );
          mediaUrls.add(fileUrl);
        }
      }

      commentDetailsEntity.comment.mediaUrl = mediaUrls;
      log("new comment data after edit: ${CommentDetailsModel.fromEntity(commentDetailsEntity).toJson()}");

      await databaseService.updateData(
        path: BackendEndpoints.updateComment,
        documentId: commentId,
        data: CommentModel.fromEntity(commentDetailsEntity.comment).toJson(),
      );

      return right(commentDetailsEntity);
    } catch (e) {
      log("Exception in CommentRepoImpl.updateComment() ${e.toString()}");
      return left(const ServerFailure(
          message: "Unable to update the comment. Please try again."));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteComment({
    required String tweetId,
    required String commentId,
    List<String>? mediaFiles,
  }) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoints.deleteComment,
        documentId: commentId,
      );

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        await storageService.deleteFiles(mediaFiles);
      }

      await databaseService.decrementField(
        path: BackendEndpoints.updateTweet,
        documentId: tweetId,
        field: "commentsCount",
      );

      return right(Success());
    } catch (e) {
      log("Exception in CommentRepoImpl.deleteComment() ${e.toString()}");
      return left(const ServerFailure(message: "Couldn't delete the comment."));
    }
  }
}
