import 'package:twitter_app/features/tweet/domain/entities/retweet_entity.dart';

class RetweetModel extends RetweetEntity {
  RetweetModel({
    required super.tweetId,
    required super.userId,
    required super.originalAuthorId,
    required super.retweetedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'userId': userId,
      'originalAuthorId': originalAuthorId,
      'retweetedAt': retweetedAt,
    };
  }

  factory RetweetModel.fromJson(Map<String, dynamic> json) {
    return RetweetModel(
      tweetId: json['tweetId'],
      userId: json['userId'],
      originalAuthorId: json['originalAuthorId'],
      retweetedAt: json['retweetedAt'],
    );
  }

  RetweetEntity toEntity() {
    return RetweetEntity(
      tweetId: tweetId,
      userId: userId,
      originalAuthorId: originalAuthorId,
      retweetedAt: retweetedAt,
    );
  }

  factory RetweetModel.fromEntity(RetweetEntity entity) {
    return RetweetModel(
      tweetId: entity.tweetId,
      userId: entity.userId,
      originalAuthorId: entity.originalAuthorId,
      retweetedAt: entity.retweetedAt,
    );
  }
}
