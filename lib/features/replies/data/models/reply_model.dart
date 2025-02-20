import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_entity.dart';

class ReplyModel extends ReplyEntity {
  ReplyModel({
    required super.commentId,
    required super.commentAuthorId,
    required super.replyAuthorId,
    required super.createdAt,
    super.content,
    super.mediaUrl,
    super.likes,
    super.updatedAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      commentId: json['commentId'],
      commentAuthorId: json['commentAuthorId'],
      replyAuthorId: json['replyAuthorId'],
      createdAt: json['createdAt'] as Timestamp,
      content: json['content'],
      mediaUrl: (json['mediaUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      likes: json['likes'] as List<dynamic>?,
      updatedAt: json['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'commentAuthorId': commentAuthorId,
      'replyAuthorId': replyAuthorId,
      'createdAt': createdAt,
      'content': content,
      'mediaUrl': mediaUrl,
      'likes': likes,
      'updatedAt': updatedAt,
    };
  }

  factory ReplyModel.fromEntity(ReplyEntity entity) {
    return ReplyModel(
      commentId: entity.commentId,
      commentAuthorId: entity.commentAuthorId,
      replyAuthorId: entity.replyAuthorId,
      createdAt: entity.createdAt,
      content: entity.content,
      mediaUrl: entity.mediaUrl,
      likes: entity.likes,
      updatedAt: entity.updatedAt,
    );
  }

  ReplyEntity toEntity() {
    return ReplyEntity(
      commentId: commentId,
      commentAuthorId: commentAuthorId,
      replyAuthorId: replyAuthorId,
      createdAt: createdAt,
      content: content,
      mediaUrl: mediaUrl,
      likes: likes,
      updatedAt: updatedAt,
    );
  }

  ReplyModel copyWith({
    String? commentId,
    String? commentAuthorId,
    String? replyAuthorId,
    Timestamp? createdAt,
    String? content,
    List<String>? mediaUrl,
    List<dynamic>? likes,
    Timestamp? updatedAt,
  }) {
    return ReplyModel(
      commentId: commentId ?? this.commentId,
      commentAuthorId: commentAuthorId ?? this.commentAuthorId,
      replyAuthorId: replyAuthorId ?? this.replyAuthorId,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      likes: likes ?? this.likes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
