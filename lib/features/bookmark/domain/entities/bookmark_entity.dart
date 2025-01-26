import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkEntity {
  final String userId;
  final String originalAuthorId;
  final String tweetId;
  final Timestamp bookmarkedAt;

  BookmarkEntity({
    required this.userId,
    required this.originalAuthorId,
    required this.tweetId,
    required this.bookmarkedAt,
  });
}
