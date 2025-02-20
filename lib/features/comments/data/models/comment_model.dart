import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.tweetId,
    required super.tweetAuthorId,
    required super.commentAuthorId,
    required super.createdAt,
    super.content,
    super.mediaUrl,
    super.updatedAt,
    super.likes,
    super.repliesCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'tweetAuthorId': tweetAuthorId,
      'commentAuthorId': commentAuthorId,
      'content': content,
      'mediaUrl': mediaUrl,
      'updatedAt': updatedAt,
      'likes': likes,
      'repliesCount': repliesCount,
      'createdAt': createdAt,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      tweetId: json['tweetId'] as String,
      tweetAuthorId:
          json['tweetAuthorId'],
      commentAuthorId:
          json['commentAuthorId'],
      createdAt: json['createdAt'] as Timestamp,
      content: json['content'] as String?,
      mediaUrl: (json['mediaUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedAt: json['updatedAt'] as Timestamp?,
      likes: json['likes'],
      repliesCount: json['repliesCount'],
    );
  }

  CommentEntity toEntity() {
    return CommentEntity(
      tweetId: tweetId,
      tweetAuthorId: tweetAuthorId,
      commentAuthorId: commentAuthorId,
      createdAt: createdAt,
      content: content,
      mediaUrl: mediaUrl,
      updatedAt: updatedAt,
      likes: likes,
      repliesCount: repliesCount,
    );
  }

  factory CommentModel.fromEntity(CommentEntity entity) {
    return CommentModel(
      tweetId: entity.tweetId,
      tweetAuthorId: entity.tweetAuthorId,
      commentAuthorId: entity.commentAuthorId,
      createdAt: entity.createdAt,
      content: entity.content,
      mediaUrl: entity.mediaUrl,
      updatedAt: entity.updatedAt,
      likes: entity.likes,
      repliesCount: entity.repliesCount,
    );
  }

  CommentModel copyWith({
    String? tweetId,
    String? tweetAuthorId,
    String? commentAuthorId,
    Timestamp? createdAt,
    String? content,
    List<String>? mediaUrl,
    Timestamp? updatedAt,
    dynamic likes,
    dynamic repliesCount,
  }) {
    return CommentModel(
      tweetId: tweetId ?? this.tweetId,
      tweetAuthorId: tweetAuthorId ?? this.tweetAuthorId,
      commentAuthorId: commentAuthorId ?? this.commentAuthorId,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      repliesCount: repliesCount ?? this.repliesCount,
    );
  }
}
