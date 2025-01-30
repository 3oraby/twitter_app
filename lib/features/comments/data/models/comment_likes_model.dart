import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_likes_entity.dart';

class CommentLikesModel extends CommentLikesEntity {
  CommentLikesModel({
    required super.commentId,
    required super.userId,
    required super.originalAuthorId,
    required super.likedAt,
  });

  factory CommentLikesModel.fromJson(Map<String, dynamic> json) {
    return CommentLikesModel(
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      originalAuthorId: json['originalAuthorId'] as String,
      likedAt: json['likedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'originalAuthorId': originalAuthorId,
      'likedAt': likedAt,
    };
  }

  CommentLikesEntity toEntity() {
    return CommentLikesEntity(
      commentId: commentId,
      userId: userId,
      originalAuthorId: originalAuthorId,
      likedAt: likedAt,
    );
  }

  factory CommentLikesModel.fromEntity(CommentLikesEntity entity) {
    return CommentLikesModel(
      commentId: entity.commentId,
      userId: entity.userId,
      originalAuthorId: entity.originalAuthorId,
      likedAt: entity.likedAt,
    );
  }
}
