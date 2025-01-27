import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.tweetId,
    required super.tweetAuthorData,
    required super.commentAuthorData,
    required super.createdAt,
    super.content,
    super.mediaUrl,
    super.updatedAt,
    super.likes,
    super.bookmarks,
    super.retweets,
  });

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'tweetAuthorData': UserModel.fromEntity(tweetAuthorData).toJson(),
      'commentAuthorData': UserModel.fromEntity(commentAuthorData).toJson(),
      'content': content,
      'mediaUrl': mediaUrl,
      'updatedAt': updatedAt,
      'likes': likes,
      'bookmarks': bookmarks,
      'retweets': retweets,
      'createdAt': createdAt,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      tweetId: json['tweetId'] as String,
      tweetAuthorData:
          UserModel.fromJson(json['tweetAuthorData'] as Map<String, dynamic>)
              .toEntity(),
      commentAuthorData:
          UserModel.fromJson(json['commentAuthorData'] as Map<String, dynamic>)
              .toEntity(),
      createdAt: json['createdAt'] as Timestamp,
      content: json['content'] as String?,
      mediaUrl: (json['mediaUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedAt: json['updatedAt'] as Timestamp?,
      likes: json['likes'],
      bookmarks: json['bookmarks'],
      retweets: json['retweets'],
    );
  }

  CommentEntity toEntity() {
    return CommentEntity(
      tweetId: tweetId,
      tweetAuthorData: tweetAuthorData,
      commentAuthorData: commentAuthorData,
      createdAt: createdAt,
      content: content,
      mediaUrl: mediaUrl,
      updatedAt: updatedAt,
      likes: likes,
      bookmarks: bookmarks,
      retweets: retweets,
    );
  }

  factory CommentModel.fromEntity(CommentEntity entity) {
    return CommentModel(
      tweetId: entity.tweetId,
      tweetAuthorData: entity.tweetAuthorData,
      commentAuthorData: entity.commentAuthorData,
      createdAt: entity.createdAt,
      content: entity.content,
      mediaUrl: entity.mediaUrl,
      updatedAt: entity.updatedAt,
      likes: entity.likes,
      bookmarks: entity.bookmarks,
      retweets: entity.retweets,
    );
  }
}
