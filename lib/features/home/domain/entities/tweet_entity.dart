import 'package:cloud_firestore/cloud_firestore.dart';

class TweetEntity {
  // final String tweetId;
  final String userId;
  String? content;
  List<String>? mediaUrl;
  final Timestamp createdAt;
  Timestamp? updatedAt;
  int likesCount;
  int commentsCount;
  int retweetsCount;

  TweetEntity({
    // required this.tweetId,
    required this.userId,
    required this.createdAt,
    this.content,
    this.mediaUrl,
    this.updatedAt,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.retweetsCount = 0,
  });
}
