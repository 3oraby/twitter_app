import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_likes_entity.dart';

class ReplyLikesModel extends ReplyLikesEntity {
  ReplyLikesModel({
    required super.replyId,
    required super.userId,
    required super.originalAuthorId,
    required super.likedAt,
  });

  factory ReplyLikesModel.fromJson(Map<String, dynamic> json) {
    return ReplyLikesModel(
      replyId: json['replyId'] as String,
      userId: json['userId'] as String,
      originalAuthorId: json['originalAuthorId'] as String,
      likedAt: json['likedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'replyId': replyId,
      'userId': userId,
      'originalAuthorId': originalAuthorId,
      'likedAt': likedAt,
    };
  }

  ReplyLikesEntity toEntity() {
    return ReplyLikesEntity(
      replyId: replyId,
      userId: userId,
      originalAuthorId: originalAuthorId,
      likedAt: likedAt,
    );
  }

  factory ReplyLikesModel.fromEntity(ReplyLikesEntity entity) {
    return ReplyLikesModel(
      replyId: entity.replyId,
      userId: entity.userId,
      originalAuthorId: entity.originalAuthorId,
      likedAt: entity.likedAt,
    );
  }
}
