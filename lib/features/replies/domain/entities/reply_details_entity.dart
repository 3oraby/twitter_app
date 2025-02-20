import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_entity.dart';

class ReplyDetailsEntity {
  final String commentId;
  final String replyId;
  final ReplyEntity reply;
  final UserEntity commentAuthorData;
  final UserEntity replyAuthorData;
  bool isLiked;

  ReplyDetailsEntity({
    required this.commentId,
    required this.replyId,
    required this.reply,
    required this.commentAuthorData,
    required this.replyAuthorData,
    this.isLiked = false,
  });
}
