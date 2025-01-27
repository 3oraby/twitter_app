import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/comments/presentation/screens/make_new_comment_screen.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomCommentButton extends StatelessWidget {
  const CustomCommentButton({
    super.key,
    required this.commentsCount,
    required this.tweetDetailsEntity,
  });

  final int commentsCount;
  final TweetDetailsEntity tweetDetailsEntity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          MakeNewCommentScreen.routeId,
          arguments: tweetDetailsEntity,
        );
      },
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.comment,
            color: AppColors.thirdColor,
          ),
          const HorizontalGap(6),
          Text(
            commentsCount.toString(),
            style: AppTextStyles.uberMoveMedium18.copyWith(
              color: AppColors.thirdColor,
            ),
          ),
        ],
      ),
    );
  }
}
