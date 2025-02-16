import 'dart:developer';

import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/bookmark/data/models/bookmark_model.dart';
import 'package:twitter_app/features/bookmark/domain/repos/bookmark_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';

class BookmarkRepoImpl extends BookmarkRepo {
  final DatabaseService databaseService;
  BookmarkRepoImpl({required this.databaseService});
  @override
  Future<Either<Failure, Success>> toggleBookmark({
    required Map<String, dynamic> data,
  }) async {
    try {
      BookmarkModel bookmarkModel = BookmarkModel.fromJson(data);
      String path = BackendEndpoints.toggleBookMarks;

      var existingBookmark = await databaseService.getData(
        path: BackendEndpoints.toggleBookMarks,
        queryConditions: [
          QueryCondition(
            field: "userId",
            value: bookmarkModel.userId,
          ),
          QueryCondition(
            field: "tweetId",
            value: bookmarkModel.tweetId,
          ),
        ],
      );

      if (existingBookmark.isEmpty) {
        await databaseService.addData(
          path: path,
          data: bookmarkModel.toJson(),
        );
      } else {
        await databaseService.deleteData(
          path: path,
          documentId: existingBookmark.first.id,
        );
      }

      return right(Success());
    } catch (e) {
      log("Exception in BookmarkRepoImpl.toggleBookmark() ${e.toString()}");
      return left(
          ServerFailure(message: "Unable to update the bookmark status."));
    }
  }
}
