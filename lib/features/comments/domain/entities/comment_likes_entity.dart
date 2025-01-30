import 'package:cloud_firestore/cloud_firestore.dart';

class CommentLikesEntity {
  final String commentId;
  final String userId;
  final String originalAuthorId;
  final Timestamp likedAt;

  CommentLikesEntity({
    required this.commentId,
    required this.userId,
    required this.originalAuthorId,
    required this.likedAt,
  });
}
