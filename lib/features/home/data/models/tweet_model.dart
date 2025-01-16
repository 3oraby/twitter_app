import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/home/domain/entities/tweet_entity.dart';

class TweetModel extends TweetEntity {
  TweetModel({
    required super.userId,
    required super.createdAt,
    super.content,
    super.mediaUrl,
    super.updatedAt,
    super.likesCount,
    super.commentsCount,
    super.retweetsCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'content': content,
      'mediaUrl': mediaUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'retweetsCount': retweetsCount,
    };
  }

  factory TweetModel.fromMap(Map<String, dynamic> map) {
    return TweetModel(
      userId: map['userId'] as String,
      content: map['content'] as String?,
      mediaUrl:
          (map['mediaUrl'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: map['createdAt'] as Timestamp,
      updatedAt: map['updatedAt'] as Timestamp?,
      likesCount: map['likesCount'] as int? ?? 0,
      commentsCount: map['commentsCount'] as int? ?? 0,
      retweetsCount: map['retweetsCount'] as int? ?? 0,
    );
  }

  TweetEntity toEntity() {
    return TweetEntity(
      userId: userId,
      content: content,
      mediaUrl: mediaUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likesCount: likesCount,
      commentsCount: commentsCount,
      retweetsCount: retweetsCount,
    );
  }

  factory TweetModel.fromEntity(TweetEntity entity) {
    return TweetModel(
      userId: entity.userId,
      content: entity.content,
      mediaUrl: entity.mediaUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      likesCount: entity.likesCount,
      commentsCount: entity.commentsCount,
      retweetsCount: entity.retweetsCount,
    );
  }
}
