import 'package:cloud_firestore/cloud_firestore.dart';

class TweetLikesEntity {
  final String tweetId;
  final String userId;
  final String originalAuthorId;
  final Timestamp likedAt;

  TweetLikesEntity({
    required this.tweetId,
    required this.userId,
    required this.originalAuthorId,
    required this.likedAt,
  });
}
