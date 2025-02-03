
import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/get_time_ago.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/widgets/custom_reply_like_button.dart';

class CustomReplyInteractionsRow extends StatelessWidget {
  const CustomReplyInteractionsRow({
    super.key,
    required this.replyDetailsEntity,
    // required this.onReplyButtonPressed,
  });

  final ReplyDetailsEntity replyDetailsEntity;
  // final ValueChanged<ReplyDetailsEntity> onReplyButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          getTimeAgo(replyDetailsEntity.reply.createdAt),
          style: AppTextStyles.uberMoveBold16.copyWith(
            color: AppColors.thirdColor,
          ),
        ),
        const HorizontalGap(6),
        TextButton(
          onPressed: () {
            // onReplyButtonPressed(replyDetailsEntity);
          },
          child: Text(
            "Reply",
            style: AppTextStyles.uberMoveExtraBold18.copyWith(
              color: AppColors.thirdColor,
            ),
          ),
        ),
        Spacer(),
        CustomReplyLikeButton(
          replyId: replyDetailsEntity.replyId,
          originalAuthorId:
              replyDetailsEntity.reply.replyAuthorData.userId,
          likesCount: replyDetailsEntity.reply.likes?.length ?? 0,
          isActive: replyDetailsEntity.isLiked,
        ),
      ],
    );
  }
}
