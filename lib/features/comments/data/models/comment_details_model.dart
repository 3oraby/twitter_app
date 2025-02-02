import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_entity.dart';

class CommentDetailsModel extends CommentDetailsEntity {
  CommentDetailsModel({
    required super.tweetId,
    required super.commentId,
    required super.comment,
    super.isLiked,
  });

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'commentId': commentId,
      'comment': comment,
      'isLiked': isLiked,
    };
  }

  factory CommentDetailsModel.fromJson(Map<String, dynamic> json) {
    return CommentDetailsModel(
      tweetId: json['tweetId'] as String,
      commentId: json['commentId'] as String,
      comment: json['comment'] as CommentEntity,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  CommentDetailsEntity toEntity() {
    return CommentDetailsEntity(
      tweetId: tweetId,
      commentId: commentId,
      comment: comment,
      isLiked: isLiked,
    );
  }

  factory CommentDetailsModel.fromEntity(CommentDetailsEntity entity) {
    return CommentDetailsModel(
      tweetId: entity.tweetId,
      commentId: entity.commentId,
      comment: entity.comment,
      isLiked: entity.isLiked,
    );
  }
}
