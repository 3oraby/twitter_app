import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_entity.dart';

class CommentDetailsModel extends CommentDetailsEntity {
  CommentDetailsModel({
    required super.tweetId,
    required super.comment,
    super.isLiked,
    super.isBookmarked,
    super.isRetweeted,
  });

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'comment': comment,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'isRetweeted': isRetweeted,
    };
  }

  factory CommentDetailsModel.fromJson(Map<String, dynamic> json) {
    return CommentDetailsModel(
      tweetId: json['tweetId'] as String,
      comment: json['comment'] as CommentEntity,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      isRetweeted: json['isRetweeted'] as bool? ?? false,
    );
  }

  CommentDetailsEntity toEntity() {
    return CommentDetailsEntity(
      tweetId: tweetId,
      comment: comment,
      isLiked: isLiked,
      isBookmarked: isBookmarked,
      isRetweeted: isRetweeted,
    );
  }

  factory CommentDetailsModel.fromEntity(CommentDetailsEntity entity) {
    return CommentDetailsModel(
      tweetId: entity.tweetId,
      comment: entity.comment,
      isLiked: entity.isLiked,
      isBookmarked: entity.isBookmarked,
      isRetweeted: entity.isRetweeted,
    );
  }
}
