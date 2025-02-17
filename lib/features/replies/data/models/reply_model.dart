import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_entity.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';

class ReplyModel extends ReplyEntity {
  ReplyModel({
    required super.commentId,
    required super.commentAuthorData,
    required super.replyAuthorData,
    required super.createdAt,
    super.content,
    super.mediaUrl,
    super.likes,
    super.updatedAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      commentId: json['commentId'],
      commentAuthorData: UserModel.fromJson(json['commentAuthorData']),
      replyAuthorData: UserModel.fromJson(json['replyAuthorData']),
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
      'commentAuthorData': UserModel.fromEntity(commentAuthorData).toJson(),
      'replyAuthorData': UserModel.fromEntity(replyAuthorData).toJson(),
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
      commentAuthorData: entity.commentAuthorData,
      replyAuthorData: entity.replyAuthorData,
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
      commentAuthorData: commentAuthorData,
      replyAuthorData: replyAuthorData,
      createdAt: createdAt,
      content: content,
      mediaUrl: mediaUrl,
      likes: likes,
      updatedAt: updatedAt,
    );
  }

  ReplyModel copyWith({
    String? commentId,
    UserEntity? commentAuthorData,
    UserEntity? replyAuthorData,
    Timestamp? createdAt,
    String? content,
    List<String>? mediaUrl,
    List<dynamic>? likes,
    Timestamp? updatedAt,
  }) {
    return ReplyModel(
      commentId: commentId ?? this.commentId,
      commentAuthorData: commentAuthorData ?? this.commentAuthorData,
      replyAuthorData: replyAuthorData ?? this.replyAuthorData,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      likes: likes ?? this.likes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
