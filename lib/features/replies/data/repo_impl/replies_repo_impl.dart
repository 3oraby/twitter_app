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
import 'package:twitter_app/features/replies/data/models/reply_details_model.dart';
import 'package:twitter_app/features/replies/data/models/reply_model.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';

class RepliesRepoImpl extends RepliesRepo {
  final DatabaseService databaseService;
  final StorageService storageService;

  RepliesRepoImpl({
    required this.databaseService,
    required this.storageService,
  });

  @override
  Future<Either<Failure, ReplyDetailsEntity>> makeNewReply(
      {required Map<String, dynamic> data,
      required List<File>? mediaFiles}) async {
    try {
      ReplyModel replyModel = ReplyModel.fromJson(data);

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

      replyModel.mediaUrl = mediaUrl;
      String? id = await databaseService.addData(
        path: BackendEndpoints.makeNewReply,
        data: replyModel.toJson(),
      );

      await databaseService.incrementField(
        path: BackendEndpoints.updateCommentData,
        documentId: replyModel.commentId,
        field: "repliesCount",
      );

      ReplyDetailsEntity replyDetailsEntity = ReplyDetailsEntity(
        commentId: replyModel.commentId,
        replyId: id!,
        reply: replyModel.toEntity(),
      );

      return right(replyDetailsEntity);
    } catch (e) {
      log("Exception in RepliesRepoImpl.makeNewReply() ${e.toString()}");
      return const Left(
        ServerFailure(
            message:
                "Unable to send the reply right now. Please try again later."),
      );
    }
  }

  @override
  Future<Either<Failure, List<ReplyDetailsEntity>>> getCommentReplies(
      {required String commentId}) async {
    try {
      final UserEntity currentUser = getCurrentUserEntity();
      List<ReplyDetailsEntity> replies = [];
      List<String>? orderByFields = ["createdAt"];
      List<bool>? descending = [false];

      List res = await databaseService.getData(
        path: BackendEndpoints.getReplies,
        queryConditions: [
          QueryCondition(
            field: "commentId",
            value: commentId,
          ),
        ],
        orderByFields: orderByFields,
        descending: descending,
      );

      replies = res.map((doc) {
        ReplyModel replyModel = ReplyModel.fromJson(doc.data());
        bool isReplyLikedByCurrentUser =
            replyModel.likes?.contains(currentUser.userId) ?? false;

        ReplyDetailsModel replyDetailsModel = ReplyDetailsModel(
          commentId: replyModel.commentId,
          replyId: doc.id,
          reply: replyModel.toEntity(),
          isLiked: isReplyLikedByCurrentUser,
        );
        return replyDetailsModel.toEntity();
      }).toList();
      return right(replies);
    } catch (e) {
      log("Exception in RepliesRepoImpl.getCommentReplies() ${e.toString()}");
      return const Left(
        ServerFailure(
            message:
                "Unable to retrieve replies right now. Please try again later."),
      );
    }
  }

  @override
  Future<Either<Failure, Success>> deleteReply({
    required String commentId,
    required String replyId,
    List<String>? removedMediaFiles,
  }) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoints.deleteReply,
        documentId: replyId,
      );

      if (removedMediaFiles != null && removedMediaFiles.isNotEmpty) {
        await storageService.deleteFiles(removedMediaFiles);
      }

      await databaseService.decrementField(
        path: BackendEndpoints.updateComment,
        documentId: commentId,
        field: "repliesCount",
      );

      return right(Success());
    } catch (e) {
      log("Exception in ReplyRepoImpl.deleteReply() ${e.toString()}");
      return left(const ServerFailure(message: "Couldn't delete the reply."));
    }
  }

  @override
  Future<Either<Failure, ReplyDetailsEntity>> updateReply({
    required String replyId,
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

      ReplyDetailsEntity replyDetailsEntity =
          ReplyDetailsModel.fromJson(data).toEntity();

      if (mediaFiles != null) {
        for (File file in mediaFiles) {
          String fileUrl = await storageService.uploadFile(
            file,
            BackendEndpoints.uploadFiles,
          );
          mediaUrls.add(fileUrl);
        }
      }

      replyDetailsEntity.reply.mediaUrl = mediaUrls;
      log("new reply data after edit: ${ReplyDetailsModel.fromEntity(replyDetailsEntity).toJson()}");

      await databaseService.updateData(
        path: BackendEndpoints.updateReply,
        documentId: replyId,
        data: ReplyModel.fromEntity(replyDetailsEntity.reply).toJson(),
      );

      return right(replyDetailsEntity);
    } catch (e) {
      log("Exception in RepliesRepoImpl.updateReply() ${e.toString()}");
      return left(const ServerFailure(
          message: "Unable to update the reply. Please try again."));
    }
  }
}
