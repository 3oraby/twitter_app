import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_entity.dart';

class CommentDetailsModel extends CommentDetailsEntity {
  CommentDetailsModel({
    required super.tweetId,
    required super.commentId,
    required super.comment,
    required super.commentAuthorData,
    super.isLiked,
  });

  Map<String, dynamic> toJson() {
    return {
      'tweetId': tweetId,
      'commentId': commentId,
      'comment': comment,
      'isLiked': isLiked,
      'commentAuthorData': commentAuthorData,
    };
  }

  factory CommentDetailsModel.fromJson(Map<String, dynamic> json) {
    return CommentDetailsModel(
      tweetId: json['tweetId'] as String,
      commentId: json['commentId'] as String,
      comment: json['comment'] as CommentEntity,
      commentAuthorData: json['commentAuthorData'],
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  CommentDetailsEntity toEntity() {
    return CommentDetailsEntity(
      tweetId: tweetId,
      commentId: commentId,
      comment: comment,
      isLiked: isLiked,
      commentAuthorData: commentAuthorData,
    );
  }

  factory CommentDetailsModel.fromEntity(CommentDetailsEntity entity) {
    return CommentDetailsModel(
      tweetId: entity.tweetId,
      commentId: entity.commentId,
      comment: entity.comment,
      commentAuthorData: entity.commentAuthorData,
      isLiked: entity.isLiked,
    );
  }

  CommentDetailsModel copyWith({
    String? tweetId,
    String? commentId,
    CommentEntity? comment,
    UserEntity? commentAuthorData,
    bool? isLiked,
  }) {
    return CommentDetailsModel(
      tweetId: tweetId ?? this.tweetId,
      commentId: commentId ?? this.commentId,
      comment: comment ?? this.comment,
      commentAuthorData: commentAuthorData ?? this.commentAuthorData,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
