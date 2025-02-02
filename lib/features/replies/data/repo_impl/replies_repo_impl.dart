import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/storage_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
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
  Future<Either<Failure, Success>> makeNewReply(
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
      await databaseService.addData(
        path: BackendEndpoints.makeNewReply,
        data: replyModel.toJson(),
      );

      await databaseService.incrementField(
        path: BackendEndpoints.updateCommentData,
        documentId: replyModel.commentId,
        field: "repliesCount",
      );

      return right(Success());
    } catch (e) {
      log("Exception in RepliesRepoImpl.makeNewReply() ${e.toString()}");
      return Left(
        ServerFailure(
            message:
                "Can not make the reply right now ,please try again later"),
      );
    }
  }

  @override
  Future<Either<Failure, List<ReplyDetailsEntity>>> getCommentReplies(
      {required String commentId}) {
    throw UnimplementedError();
  }
}
