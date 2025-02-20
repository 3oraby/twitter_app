import 'package:cloud_firestore/cloud_firestore.dart';

class CommentEntity {
  final String tweetId;
  final String tweetAuthorId;
  final String commentAuthorId;
  String? content;
  List<String>? mediaUrl;
  Timestamp? updatedAt;
  List<dynamic>? likes;
  int repliesCount;
  final Timestamp createdAt;

  CommentEntity({
    required this.tweetId,
    required this.tweetAuthorId,
    required this.commentAuthorId,
    required this.createdAt,
    this.content,
    this.mediaUrl,
    this.updatedAt,
    this.likes,
    this.repliesCount = 0,
  });

  void incrementRepliesCount() {
    repliesCount++;
  }

  void decrementRepliesCount() {
    repliesCount--;
  }
}
