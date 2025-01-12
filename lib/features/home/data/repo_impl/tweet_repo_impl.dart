import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/storage_service.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/home/data/models/tweet_model.dart';
import 'package:twitter_app/features/home/domain/entities/tweet_entity.dart';
import 'package:twitter_app/features/home/domain/repos/tweet_repo.dart';

class TweetRepoImpl extends TweetRepo {
  final DatabaseService databaseService;
  final StorageService storageService;
  TweetRepoImpl({
    required this.databaseService,
    required this.storageService,
  });
  @override
  Future<Either<Failure, TweetEntity>> makeNewTweet({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  }) async {
    try {
      List<String> mediaUrl = [];
      if (mediaFiles != null) {
        log("media files: $mediaFiles");

        for (File file in mediaFiles) {
          String fileUrl = await storageService.uploadFile(
            file,
            BackendEndpoints.uploadFiles,
          );
          mediaUrl.add(fileUrl);
        }
      }

      log("media url: $mediaUrl");
      data["mediaUrl"] = mediaUrl;

      await databaseService.addData(
        path: BackendEndpoints.makeNewTweet,
        data: data,
      );

      return right(TweetModel.fromMap(data).toEntity());
    } catch (e) {
      log("Exception in TweetRepoImpl.makeNewTweet() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to post the tweet"));
    }
  }

  @override
  Future<Either<Failure, List<TweetEntity>>> getTweets({
    bool? isForFollowingOnly,
  }) async {
    try {
      List res = await databaseService.getData(
        path: BackendEndpoints.getTweets,
      );

      List<TweetEntity> tweets = res
          .map(
            (doc) => TweetModel.fromMap(doc.data()),
          )
          .toList();
      return right(tweets);
    } catch (e) {
      log("Exception in TweetRepoImpl.getTweets() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get the tweets"));
    }
  }
}
