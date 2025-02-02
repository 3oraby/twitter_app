import 'package:twitter_app/features/comments/domain/entities/comment_entity.dart';

class CommentDetailsEntity {
  final String tweetId;
  final String commentId;
  final CommentEntity comment;
  bool isLiked;

  CommentDetailsEntity({
    required this.tweetId,
    required this.commentId,
    required this.comment,
    this.isLiked = false,
  });
}
