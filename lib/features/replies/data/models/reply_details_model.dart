import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/data/models/reply_model.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_entity.dart';

class ReplyDetailsModel extends ReplyDetailsEntity {
  ReplyDetailsModel({
    required super.commentId,
    required super.replyId,
    required super.reply,
    required super.replyAuthorData,
    required super.commentAuthorData,
    super.isLiked,
  });

  factory ReplyDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReplyDetailsModel(
      commentId: json['commentId'],
      replyId: json['replyId'],
      reply: ReplyModel.fromJson(json['reply']),
      replyAuthorData: json['replyAuthorData'],
      commentAuthorData: json['commentAuthorData'],
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'replyId': replyId,
      'reply': ReplyModel.fromEntity(reply).toJson(),
      'replyAuthorData': replyAuthorData,
      'commentAuthorData': commentAuthorData,
      'isLiked': isLiked,
    };
  }

  factory ReplyDetailsModel.fromEntity(ReplyDetailsEntity entity) {
    return ReplyDetailsModel(
      commentId: entity.commentId,
      replyId: entity.replyId,
      reply: ReplyModel.fromEntity(entity.reply),
      replyAuthorData: entity.replyAuthorData,
      commentAuthorData: entity.commentAuthorData,
      isLiked: entity.isLiked,
    );
  }

  ReplyDetailsEntity toEntity() {
    return ReplyDetailsEntity(
      commentId: commentId,
      replyId: replyId,
      reply: reply,
      replyAuthorData: replyAuthorData,
      commentAuthorData: commentAuthorData,
      isLiked: isLiked,
    );
  }

  ReplyDetailsModel copyWith({
    String? commentId,
    String? replyId,
    ReplyEntity? reply,
    UserEntity? replyAuthorData,
    UserEntity? commentAuthorData,
    bool? isLiked,
  }) {
    return ReplyDetailsModel(
      commentId: commentId ?? this.commentId,
      replyId: replyId ?? this.replyId,
      reply: reply ?? this.reply,
      replyAuthorData: replyAuthorData ?? this.replyAuthorData,
      commentAuthorData: commentAuthorData ?? this.commentAuthorData,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
