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
      return left(const ServerFailure(
          message: "Unable to post the tweet. Please try again."));
    }
  }

  @override
  Future<Either<Failure, List<TweetDetailsEntity>>> getTweets({
    bool? isForFollowingOnly,
    bool? includeLikedTweets,
    bool? includeUserTweets,
    bool? includeTweetsWithImages,
  }) async {
    try {
      final UserEntity currentUser = getCurrentUserEntity();
      List<TweetDetailsEntity> tweets = [];
      List<QueryCondition> tweetConditions = [];

      if (isForFollowingOnly == true) {
        List followingList = await databaseService.getData(
          path: BackendEndpoints.toggleFollowRelationShip,
          queryConditions: [
            QueryCondition(field: "followingId", value: currentUser.userId),
          ],
        );

        Set<String> followingUserIds = followingList
            .map((doc) => doc.data()['followedId'] as String)
            .toSet();

        if (followingUserIds.isEmpty) return right([]);

        tweetConditions.add(QueryCondition(
          field: "userId",
          operator: QueryOperator.whereIn,
          value: followingUserIds.toList(),
        ));
      }

      if (includeUserTweets == true) {
        tweetConditions.add(
          QueryCondition(
            field: "userId",
            value: currentUser.userId,
          ),
        );
      }

      if (includeTweetsWithImages == true) {
        tweetConditions.add(
          QueryCondition(
            field: "userId",
            value: currentUser.userId,
          ),
        );
        tweetConditions.add(
          QueryCondition(
            field: "mediaUrl",
            operator: QueryOperator.isNotEqualTo,
            value: [],
          ),
        );
      }

      List tweetDocs = await databaseService.getData(
        path: BackendEndpoints.getTweets,
        queryConditions: tweetConditions.isNotEmpty ? tweetConditions : null,
      );

      if (tweetDocs.isEmpty) return right([]);

      Future<List> fetchUserData(String path) async {
        return await databaseService.getData(
          path: path,
          queryConditions: [
            QueryCondition(field: "userId", value: currentUser.userId)
          ],
        );
      }

      List likes = await fetchUserData(BackendEndpoints.getTweetLikes);
      List retweets = await fetchUserData(BackendEndpoints.getRetweets);
      List bookmarks = await fetchUserData(BackendEndpoints.getBookMarks);

      if (includeLikedTweets == true) {
        Set<String> likedTweetIds = likes
            .map((like) => TweetLikesModel.fromJson(like.data()).tweetId)
            .toSet();

        tweetDocs =
            tweetDocs.where((doc) => likedTweetIds.contains(doc.id)).toList();
      }

      Set<String> userIds =
          tweetDocs.map((doc) => TweetModel.fromMap(doc.data()).userId).toSet();
      List userDocs = await databaseService.getData(
        path: BackendEndpoints.getUserData,
        queryConditions: [
          QueryCondition(
              field: "userId",
              operator: QueryOperator.whereIn,
              value: userIds.toList()),
        ],
      );

      tweets = tweetDocs.map((doc) {
        TweetModel tweetModel = TweetModel.fromMap(doc.data());

        Map<String, dynamic> userData = userDocs
            .firstWhere(
                (userDoc) => userDoc.data()['userId'] == tweetModel.userId)
            .data();

        bool isLiked = likes.any(
            (like) => TweetLikesModel.fromJson(like.data()).tweetId == doc.id);
        bool isRetweeted = retweets.any((retweet) =>
            RetweetModel.fromJson(retweet.data()).tweetId == doc.id);
        bool isBookmarked = bookmarks.any((bookmark) =>
            BookmarkModel.fromJson(bookmark.data()).tweetId == doc.id);

        return TweetDetailsModel.fromJson({
          'tweetId': doc.id,
          'tweet': tweetModel.toJson(),
          'user': userData,
          'isLiked': isLiked,
          'isRetweeted': isRetweeted,
          'isBookmarked': isBookmarked,
        });
      }).toList();

      return right(tweets);
    } catch (e) {
      log("Exception in TweetRepoImpl.getTweets() ${e.toString()}");
      return left(const ServerFailure(
          message: "Unable to retrieve tweets. Please try again."));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteTweet({
    required String tweetId,
    List<String>? mediaFiles,
  }) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoints.deleteTweet,
        documentId: tweetId,
      );
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        await storageService.deleteFiles(mediaFiles);
      }

      return right(Success());
    } catch (e) {
      log("Exception in TweetRepoImpl.deleteTweet() ${e.toString()}");
      return left(const ServerFailure(message: "Couldn't delete the tweet."));
    }
  }

  @override
  Future<Either<Failure, TweetDetailsEntity>> updateTweet({
    required String tweetId,
    required Map<String, dynamic> data,
    required List<String>? constantMediaUrls,
    required List<String>? removedMediaUrls,
    required List<File>? mediaFiles,
  }) async {
    try {
      List<String> mediaUrls = constantMediaUrls ?? [];

      if (removedMediaUrls != null && removedMediaUrls.isNotEmpty) {
        List<String> cleanedPaths = removedMediaUrls.map((url) {
          return url.replaceFirst(
              "https://ohbgfbpjtbzfvpgsfret.supabase.co/storage/v1/object/public/twitter_images/",
              "");
        }).toList();

        log(cleanedPaths.toString());

        await storageService.deleteFiles(cleanedPaths);
      }

      TweetDetailsEntity tweetDetailsEntity =
          TweetDetailsModel.fromJson(data).toEntity();

      if (mediaFiles != null) {
        for (File file in mediaFiles) {
          String fileUrl = await storageService.uploadFile(
            file,
            BackendEndpoints.uploadFiles,
          );
          mediaUrls.add(fileUrl);
        }
      }

      tweetDetailsEntity.tweet.mediaUrl = mediaUrls;
      log("new tweet data after edit: ${TweetDetailsModel.fromEntity(tweetDetailsEntity).toJson()}");

      await databaseService.updateData(
        path: BackendEndpoints.updateTweet,
        documentId: tweetId,
        data: TweetModel.fromEntity(tweetDetailsEntity.tweet).toJson(),
      );

      return right(tweetDetailsEntity);
    } catch (e) {
      log("Exception in TweetRepoImpl.updateTweet() ${e.toString()}");
      return left(const ServerFailure(
          message: "Unable to update the tweet. Please try again."));
    }
  }
}
