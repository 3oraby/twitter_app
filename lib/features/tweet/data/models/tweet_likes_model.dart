import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_likes_entity.dart';

class TweetLikesModel extends TweetLikesEntity {
  TweetLikesModel({
    required super.tweetId,
    required super.userId,
    required super.originalAuthorId,
    required super.likedAt,
  });

  TweetLikesEntity toEntity() {
    return TweetLikesEntity(
      tweetId: tweetId,
      userId: userId,
      originalAuthorId: originalAuthorId,
      likedAt: likedAt,
    );
  }

  factory TweetLikesModel.fromEntity(TweetLikesEntity entity) {
    return TweetLikesModel(
      tweetId: entity.tweetId,
      userId: entity.userId,
      originalAuthorId: entity.originalAuthorId,
      likedAt: entity.likedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'userId': userId,
      'originalAuthorId': originalAuthorId,
      'likedAt': likedAt,
    };
  }

  factory TweetLikesModel.fromJson(Map<String, dynamic> json) {
    return TweetLikesModel(
      tweetId: json['tweetId'] as String,
      userId: json['userId'] as String,
      originalAuthorId: json['originalAuthorId'] as String,
      likedAt: json['likedAt'] as Timestamp,
    );
  }
}
