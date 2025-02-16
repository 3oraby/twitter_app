import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/storage_service.dart';
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
      return Left(
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
      return Left(
        ServerFailure(
            message:
                "Unable to retrieve replies right now. Please try again later."),
      );
    }
  }
}
