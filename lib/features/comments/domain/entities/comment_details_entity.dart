import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_entity.dart';

class CommentDetailsEntity {
  final String tweetId;
  final String commentId;
  final UserEntity commentAuthorData;
  final CommentEntity comment;
  bool isLiked;

  CommentDetailsEntity({
    required this.tweetId,
    required this.commentId,
    required this.comment,
    required this.commentAuthorData,
    this.isLiked = false,
  });

  void addLike(String likeId) {
    isLiked = true;
    comment.likes ??= [];
    comment.likes!.add(likeId);
  }

  void removeLike(String likeId) {
    isLiked = false;
    comment.likes ??= [];
    comment.likes!.remove(likeId);
  }
}
