import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyLikesEntity {
  final String replyId;
  final String userId;
  final String originalAuthorId;
  final Timestamp likedAt;

  ReplyLikesEntity({
    required this.replyId,
    required this.userId,
    required this.originalAuthorId,
    required this.likedAt,
  });
}
