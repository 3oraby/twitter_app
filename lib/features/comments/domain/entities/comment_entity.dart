import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class CommentEntity {
  final String tweetId;
  final UserEntity tweetAuthorData;
  final UserEntity commentAuthorData;
  String? content;
  List<String>? mediaUrl;
  Timestamp? updatedAt;
  List<String>? likes;
  List<String>? bookmarks;
  List<String>? retweets;
  final Timestamp createdAt;

  CommentEntity({
    required this.tweetId,
    required this.tweetAuthorData,
    required this.commentAuthorData,
    required this.createdAt,
    this.content,
    this.mediaUrl,
    this.updatedAt,
    this.likes,
    this.bookmarks,
    this.retweets,
  });
}
