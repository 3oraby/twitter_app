import 'package:twitter_app/features/comments/domain/entities/comment_entity.dart';

class CommentDetailsEntity {
  final String tweetId;
  final String commentId;
  final CommentEntity comment;
  bool isLiked;
  bool isRetweeted;
  bool isBookmarked;

  CommentDetailsEntity({
    required this.tweetId,
    required this.commentId,
    required this.comment,
    this.isLiked = false,
    this.isRetweeted = false,
    this.isBookmarked = false,
  });
}
