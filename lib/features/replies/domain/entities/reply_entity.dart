import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class ReplyEntity {
  final String commentId;
  final UserEntity commentAuthorData;
  final UserEntity replyAuthorData;
  String? content;
  List<String>? mediaUrl;
  Timestamp? updatedAt;
  List<dynamic>? likes;
  final Timestamp createdAt;

  ReplyEntity({
    required this.commentId,
    required this.commentAuthorData,
    required this.replyAuthorData,
    required this.createdAt,
    this.content,
    this.mediaUrl,
    this.likes,
    this.updatedAt,
  });
}
