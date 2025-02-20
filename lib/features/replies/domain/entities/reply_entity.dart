import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyEntity {
  final String commentId;
  final String commentAuthorId;
  final String replyAuthorId;
  String? content;
  List<String>? mediaUrl;
  Timestamp? updatedAt;
  List<dynamic>? likes;
  final Timestamp createdAt;

  ReplyEntity({
    required this.commentId,
    required this.commentAuthorId,
    required this.replyAuthorId,
    required this.createdAt,
    this.content,
    this.mediaUrl,
    this.likes,
    this.updatedAt,
  });
}
