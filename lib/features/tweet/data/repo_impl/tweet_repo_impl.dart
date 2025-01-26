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
import 'package:twitter_app/features/bookmark/data/models/bookmark_model.dart';
import 'package:twitter_app/features/tweet/data/models/retweet_model.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_details_model.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_likes_model.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_model.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_entity.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';

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
  Future<Either<Failure, List<TweetDetailsEntity>>> getTweets({
    bool? isForFollowingOnly,
  }) async {
    try {
      final UserEntity currentUser = getCurrentUserEntity();
      List<TweetDetailsEntity> tweets = [];
      await databaseService.runTransaction(
        (transaction) async {
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
            bool isLikedByCurrentUser =
                tweetIdsLikedByCurrentUser.contains(doc.id);

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
        },
      );
      return right(tweets);
    } catch (e) {
      log("Exception in TweetRepoImpl.getTweets() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to get the tweets"));
    }
  }
}
