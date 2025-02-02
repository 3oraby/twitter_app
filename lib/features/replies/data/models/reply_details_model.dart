import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/data/models/reply_model.dart';

class ReplyDetailsModel extends ReplyDetailsEntity {
  ReplyDetailsModel({
    required super.commentId,
    required super.replyId,
    required super.reply,
    super.isLiked,
  });

  factory ReplyDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReplyDetailsModel(
      commentId: json['commentId'],
      replyId: json['replyId'],
      reply: ReplyModel.fromJson(json['reply']),
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'replyId': replyId,
      'reply': (reply as ReplyModel).toJson(),
      'isLiked': isLiked,
    };
  }

  factory ReplyDetailsModel.fromEntity(ReplyDetailsEntity entity) {
    return ReplyDetailsModel(
      commentId: entity.commentId,
      replyId: entity.replyId,
      reply: ReplyModel.fromEntity(entity.reply),
      isLiked: entity.isLiked,
    );
  }

  ReplyDetailsEntity toEntity() {
    return ReplyDetailsEntity(
      commentId: commentId,
      replyId: replyId,
      reply: reply,
      isLiked: isLiked,
    );
  }
}
