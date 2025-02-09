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
import 'package:twitter_app/features/bookmark/data/models/bookmark_model.dart';
import 'package:twitter_app/features/tweet/data/models/retweet_model.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_details_model.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_likes_model.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_model.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';

class TweetRepoImpl extends TweetRepo {
  final DatabaseService databaseService;
  final StorageService storageService;
  TweetRepoImpl({
    required this.databaseService,
    required this.storageService,
  });
  @override
  Future<Either<Failure, TweetDetailsEntity>> makeNewTweet({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  }) async {
    try {
      List<String> mediaUrl = [];
      final UserEntity currentUser = getCurrentUserEntity();
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

      data["mediaUrl"] = mediaUrl;

      String? tweetId = await databaseService.addData(
        path: BackendEndpoints.makeNewTweet,
        data: data,
      );

      TweetModel tweetModel = TweetModel.fromMap(data);

      TweetDetailsModel tweetDetailsModel = TweetDetailsModel(
        tweetId: tweetId!,
        tweet: tweetModel.toEntity(),
        user: currentUser,
      );

      return right(tweetDetailsModel.toEntity());
    } catch (e) {
      log("Exception in TweetRepoImpl.makeNewTweet() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to post the tweet"));
    }
  }

  @override
  Future<Either<Failure, List<TweetDetailsEntity>>> getTweets({
    bool? isForFollowingOnly,
  }) async {
    try {
      final UserEntity currentUser = getCurrentUserEntity();
      List<TweetDetailsEntity> tweets = [];
      List res = await databaseService.getData(
        path: BackendEndpoints.getTweets,
      );

      List likes = await databaseService.getData(
        path: BackendEndpoints.getTweetLikes,
        queryConditions: [
          QueryCondition(
            field: "userId",
            value: currentUser.userId,
          ),
        ],
      );

      List retweets = await databaseService.getData(
        path: BackendEndpoints.getRetweets,
        queryConditions: [
          QueryCondition(
            field: "userId",
            value: currentUser.userId,
          ),
        ],
      );

      List bookmarks = await databaseService.getData(
        path: BackendEndpoints.getBookMarks,
        queryConditions: [
          QueryCondition(
            field: "userId",
            value: currentUser.userId,
          ),
        ],
      );

      Set<String> userIds =
          res.map((doc) => TweetModel.fromMap(doc.data()).userId).toSet();
      List userDocs = await databaseService.getData(
        path: BackendEndpoints.getUserData,
        queryConditions: [
          QueryCondition(
            field: "userId",
            operator: QueryOperator.whereIn,
            value: userIds.toList(),
          ),
        ],
      );

      tweets = res.map((doc) {
        TweetModel tweetModel = TweetModel.fromMap(doc.data());

        var userDoc = userDocs.firstWhere(
          (userDoc) => userDoc.data()['userId'] == tweetModel.userId,
        );

        Map<String, dynamic> userData = userDoc.data();

        Set<String> tweetIdsLikedByCurrentUser = likes
            .map(
              (doc) => TweetLikesModel.fromJson(doc.data()).tweetId,
            )
            .toSet();
        bool isLikedByCurrentUser = tweetIdsLikedByCurrentUser.contains(doc.id);

        Set<String> tweetIdsRetweetedByCurrentUser = retweets
            .map(
              (doc) => RetweetModel.fromJson(doc.data()).tweetId,
            )
            .toSet();

        bool isRetweetedByCurrentUser =
            tweetIdsRetweetedByCurrentUser.contains(doc.id);

        Set<String> tweetIdsBookmarkedByCurrentUser = bookmarks
            .map(
              (doc) => BookmarkModel.fromJson(doc.data()).tweetId,
            )
            .toSet();

        bool isBookmarkedByCurrentUser =
            tweetIdsBookmarkedByCurrentUser.contains(doc.id);
        Map<String, dynamic> data = {
          'tweetId': doc.id,
          'tweet': tweetModel.toJson(),
          'user': userData,
          'isLiked': isLikedByCurrentUser,
          'isRetweeted': isRetweetedByCurrentUser,
          'isBookmarked': isBookmarkedByCurrentUser,
        };

        return TweetDetailsModel.fromJson(data);
      }).toList();
      return right(tweets);
    } catch (e) {
      log("Exception in TweetRepoImpl.getTweets() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get the tweets"));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteTweet(
      {required String tweetId}) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoints.deleteTweet,
        documentId: tweetId,
      );

      return right(Success());
    } catch (e) {
      log("Exception in TweetRepoImpl.deleteTweet() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to delete the tweet"));
    }
  }

  @override
  Future<Either<Failure, TweetDetailsEntity>> updateTweet({
    required String tweetId,
    required Map<String, dynamic> data,
    required List<String>? oldMediaUrls,
    required List<File>? mediaFiles,
  }) async {
    try {
      List<String> updatedMediaUrls = oldMediaUrls ?? [];
      TweetDetailsEntity tweetDetailsEntity =
          TweetDetailsModel.fromJson(data).toEntity();
      log("old-- $oldMediaUrls");
      log("new-- ${tweetDetailsEntity.tweet.mediaUrl}");
      if (oldMediaUrls != null && tweetDetailsEntity.tweet.mediaUrl != null) {
        log("deleeeeeete");
        List<String> removedMedia = oldMediaUrls
            .where((url) =>
                !(tweetDetailsEntity.tweet.mediaUrl as List).contains(url))
            .toList();

        if (removedMedia.isNotEmpty) {
          await storageService.deleteFiles(removedMedia);
          updatedMediaUrls.removeWhere((url) => removedMedia.contains(url));
        }
      }

      if (mediaFiles != null) {
        for (File file in mediaFiles) {
          String fileUrl = await storageService.uploadFile(
            file,
            BackendEndpoints.uploadFiles,
          );
          updatedMediaUrls.add(fileUrl);
        }
      }

      tweetDetailsEntity.tweet.mediaUrl = updatedMediaUrls;
      log("new tweet data after edit: ${TweetDetailsModel.fromEntity(tweetDetailsEntity).toJson()}");

      await databaseService.updateData(
        path: BackendEndpoints.updateTweet,
        documentId: tweetId,
        data: TweetModel.fromEntity(tweetDetailsEntity.tweet).toJson(),
      );

      return right(tweetDetailsEntity);
    } catch (e) {
      log("Exception in TweetRepoImpl.updateTweet() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to update the tweet"));
    }
  }
}
