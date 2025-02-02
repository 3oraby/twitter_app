import 'package:twitter_app/features/replies/domain/entities/reply_entity.dart';

class ReplyDetailsEntity {
  final String commentId;
  final String replyId;
  final ReplyEntity reply;
  bool isLiked;

  ReplyDetailsEntity({
    required this.commentId,
    required this.replyId,
    required this.reply,
    this.isLiked = false,
  });
}
