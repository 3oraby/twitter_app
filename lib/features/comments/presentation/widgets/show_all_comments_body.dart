import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_comment_info_card.dart';

class ShowAllCommentsBody extends StatelessWidget {
  const ShowAllCommentsBody({
    super.key,
    required this.comments,
  });

  final List<CommentDetailsEntity> comments;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VerticalGap(24),
        for (int index = 0; index < comments.length; index++) ...[
          CustomCommentInfoCard(
            commentDetailsEntity: comments[index],
          ),
          if (index != comments.length - 1)
            const Divider(
              color: AppColors.dividerColor,
              height: 24,
            ),
        ],
        const VerticalGap(32),
      ],
    );
  }
}
