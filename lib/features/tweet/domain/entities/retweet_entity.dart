import 'package:cloud_firestore/cloud_firestore.dart';

class RetweetEntity {
  final String tweetId;
  final String userId;
  final String originalAuthorId;
  final Timestamp retweetedAt;

  RetweetEntity({
    required this.tweetId,
    required this.userId,
    required this.originalAuthorId,
    required this.retweetedAt,
  });
}
